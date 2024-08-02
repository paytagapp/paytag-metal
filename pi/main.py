#!/usr/bin/python

import time
import threading
from Server import Server
from typing import Dict, List
from datetime import datetime, timedelta
from TagData import TagData
import copy
import statistics
import RPi.GPIO as GPIO       # Comment GPIO
import asyncio
from PaytagServer import PaytagServer
from simple_websocket_server import WebSocketServer, WebSocket
import dataclasses, json
import configparser

# Load configuration
config = configparser.ConfigParser()
config.read('config.ini')

# Define global constants from config file
GPIO_PIN_2 = config.getint('DEFAULT', 'GPIO_PIN_2')
GPIO_PIN_3 = config.getint('DEFAULT', 'GPIO_PIN_3')
BURNER_ON_DURATION = config.getint('DEFAULT', 'BURNER_ON_DURATION')
HOLD_IN_TUB_DURATION = config.getint('DEFAULT', 'HOLD_IN_TUB_DURATION')
HISTORY_LIMIT = config.getint('DEFAULT', 'HISTORY_LIMIT')
STABLE_ITEMS_MEDIAN_THRESHOLD = config.getint('DEFAULT', 'STABLE_ITEMS_MEDIAN_THRESHOLD')
REMOVE_OLD_ENTRIES_THRESHOLD = config.getint('DEFAULT', 'REMOVE_OLD_ENTRIES_THRESHOLD')
STABLE_ITEMS_DURATION_THRESHOLD = config.getint('DEFAULT', 'STABLE_ITEMS_DURATION_THRESHOLD')
WEB_SOCKET_PORT = config.getint('DEFAULT', 'WEB_SOCKET_PORT')
SERVER_PORT = config.getint('DEFAULT', 'SERVER_PORT')

last_received_time_in_scanning = time.time()
last_received_time_in_other = time.time()
CHECK_INTERVAL = 1
INACTIVITY_THRESHOLD_FOR_SCANNING_SCREENS = config.getint('DEFAULT', 'INACTIVITY_THRESHOLD_FOR_SCANNING_SCREENS') # 10 seconds
INACTIVITY_THRESHOLD_FOR_OTHER_SCREENS = config.getint('DEFAULT', 'INACTIVITY_THRESHOLD_FOR_OTHER_SCREENS') # 10 minutes 

SLEEP_TIME_ON_CANCEL = config.getint('DEFAULT', 'SLEEP_TIME_ON_CANCEL') 

def check_inactivity():
    global last_received_time_in_scanning
    global last_received_time_in_other
    while True:
        time.sleep(CHECK_INTERVAL)  # Wait for the check interval
        current_time = time.time()
        
        if current_time - last_received_time_in_scanning > INACTIVITY_THRESHOLD_FOR_SCANNING_SCREENS:
            print("--------INACTIVTE FOR PAST 10 SECONDS---------")
            broadcast(json.dumps({
                "message": "NO ITEM IN CART - SCANNING SCREEN"
            }))
            # Reset last_received_time_in_scanning to prevent repeated broadcasting
            last_received_time_in_scanning = current_time
            
        if current_time - last_received_time_in_other > INACTIVITY_THRESHOLD_FOR_OTHER_SCREENS:
            print("*******************INACTIVTE FOR PAST 10 MINUTES*********************")
            broadcast(json.dumps({
                "message": "NO ITEM IN CART - OTHER SCREEN"
            }))
            # Reset last_received_time_in_scanning to prevent repeated broadcasting
            last_received_time_in_other = current_time
            
def on_data(raw_data, addr):
    global hold_in_tub
    global cart_check_timer
    global last_received_time_in_scanning
    global last_received_time_in_other
    # Update the last received time
    last_received_time_in_scanning = time.time()
    last_received_time_in_other = time.time()
    
    if (hold_in_tub == False):
        print("Hold in tub for 3 seconds...**********")
        broadcast("HOLD IN TUB") # Ask to hold bag in tub
        hold_in_tub = True
        cart_check_timer = time.time() + HOLD_IN_TUB_DURATION  # Start the timer 
    
    # print(f"Custom handler: Received data from {addr}: {raw_data.decode()}")
    data = raw_data.decode()
    lines = data.splitlines()
    for line in lines:
        split_line = line.split(',')
        id = split_line[0]
        count = split_line[1]
        last_read = split_line[2]
        update_dict(TagData(
            id=id,
            count=int(count),
            last_read=time.time()
        ))
    
def update_dict(new_tag_data: TagData):
    tag_data = tag_dict.get(new_tag_data.id)
    if tag_data:
        tag_data.count += new_tag_data.count
        tag_data.last_read = new_tag_data.last_read
    else:
        tag_dict[new_tag_data.id] = new_tag_data

def print_dicts():
    for key, avg in avg_dict.items():
        print(f"{key}: {avg} (in: {duration_dict[key]:.1f}s) (total: {history_dict[key]})")
    print("------------- count: " +  str(len(delta_dict)))
    print("")

def calculate_delta_dict():
    for key, tag_data in tag_dict.items():
        if key in last_tag_dict:
            last_tag_data = last_tag_dict[key]
            delta_count = tag_data.count - last_tag_data.count
            # print(f"key: {key}, tag_data.count: {tag_data.count}, last_tag_data.count: {last_tag_data.count}, delta_count: {delta_count}")
            delta_dict[key] = delta_count
        else:
            # If the key is not in last_tag_dict, you may decide to skip it or handle it differently
            delta_dict[key] = tag_data.count

def update_history() -> None:
    for key, value in delta_dict.items():
        if key in history_dict:
            history_dict[key].append(value)
            # Keep only the last X items
            history_dict[key] = history_dict[key][-HISTORY_LIMIT:]
        else:
            history_dict[key] = [value]
            
        avg_dict[key] = int(statistics.median(history_dict[key]))

def remove_old_entries():
    current_time = datetime.now()
    keys_to_remove = []
    
    for key, tag_data in tag_dict.items():
        last_read_time = datetime.fromtimestamp(tag_data.last_read)
        if (current_time - last_read_time).total_seconds() > REMOVE_OLD_ENTRIES_THRESHOLD:
            keys_to_remove.append(key)
    
    for key in keys_to_remove:
        del tag_dict[key]
        if key in last_tag_dict:
            del last_tag_dict[key]
        if key in delta_dict:
            del delta_dict[key]
        if key in history_dict:
            del history_dict[key]
        if key in avg_dict:
            del avg_dict[key]

def get_stable_items() -> List[str]:
    stable_items = []
    for key in tag_dict.keys():
        if key in avg_dict and key in duration_dict:
            if avg_dict[key] > STABLE_ITEMS_MEDIAN_THRESHOLD and duration_dict[key] > STABLE_ITEMS_DURATION_THRESHOLD:
                stable_items.append(key)
    return stable_items

def turn_on_burners():
    global burners_thread
    global last_server_result
    global hold_in_tub
    print("Verification call.............")
    result = PaytagServer.findPaidCartWithItems(get_stable_items())
    last_server_result = result
    print("***********< RESULT >************")
    print(result)
    if result.get("status"):
		# Set the GPIO mode
        GPIO.setmode(GPIO.BCM)                                          # Comment GPIO
        # Set up GPIO 2 as an output
        GPIO.setup(GPIO_PIN_2, GPIO.OUT, initial=GPIO.LOW)              # Comment GPIO
        GPIO.setup(GPIO_PIN_3, GPIO.OUT, initial=GPIO.LOW)              # Comment GPIO
        
        try:
       		# Turn on GPIO 2
            GPIO.output(GPIO_PIN_2, GPIO.HIGH)                          # Comment GPIO
            GPIO.output(GPIO_PIN_3, GPIO.HIGH)                          # Comment GPIO
			# Wait for 2 seconds
            print("GPIO turned on.")
            time.sleep(BURNER_ON_DURATION)
            GPIO.output(GPIO_PIN_2, GPIO.LOW)                           # Comment GPIO
            GPIO.output(GPIO_PIN_3, GPIO.LOW)                           # Comment GPIO
            
            print("Hold in tub flag:")
            print(hold_in_tub)
            if (hold_in_tub == True):
                broadcast(json.dumps({
                    "message": "SUCCESSFULLY NEUTRALIZED",
                    "paidTags": result.get("tagIdsPaid")
                }))
            print("GPIO turned off.")
            print("Successfully Neutralized tags:")
            print(result.get("tagIdsPaid"))
        except Exception as e:
            print(f"An error occurred: {e}")
        finally:
            GPIO.output(GPIO_PIN_2, GPIO.LOW)                           # Comment GPIO
            GPIO.output(GPIO_PIN_3, GPIO.LOW)                           # Comment GPIO
            print("GPIO cleanup done.")
    elif result.get("tagIdsNotPaid") is not None and len(result.get("tagIdsNotPaid")) > 0:
        broadcast(json.dumps({
            "message": "UNPAID TAGS",
            "unpaidTags": result.get("tagIdsNotPaid"),
            "inputTags": result.get("tagIdsInput"),                    # For Invoice number input screen
        }))
        # broadcast(json.dumps({
        #     "message": "UNPAID TAGS",
        #     # "inputTags": ['3034DB85C00B794000000028', '3034DB85C00B794000000030', '3034DB85C00B794000000028', '3034DB85C00B79400000002B', '3034DB85C00B794000000030', 'E2806810000000390D11EC76', '3034DB85C00B79400000002A', '3034DB85C00B79400000002F', '3034DB85C00B794000000029', '53FC3255510001', '5377E249010001', '3034DB85C00B794000000031'],
        #     "inputTags": ['3034DB85C00B79400000002A', '3034DB85C00B79400000002D', '3034DB85C00B794000000028', '3034DB85C00B794000000028', '3034DB85C00B79400000002B', '3034DB85C00B794000000030', '3034DB85C00B794000000029'],
        #     "unpaidTags": ['3034DB85C00B79400000002A', '3034DB85C00B79400000002D' '3034DB85C00B794000000028']
        # }))
        print("Unpaid tags:")
        print(result.get("tagIdsNotPaid"))
        print("Input tags:")
        print(result.get("tagIdsInput"))
        
    elif result.get("tagIdsNotFound") is not None and len(result.get("tagIdsNotFound")) > 0:
        broadcast(json.dumps({
            "message": "TAG NOT FOUND",
            "notFoundTags": result.get("tagIdsNotFound")
        }))
        print("Not found tags:")
        print(result.get("tagIdsNotFound"))
        
    elif result.get("error"):
        print("Error:")
        print(result.get("error"))
        
    else:
        print("Unknown result:")
        print(result)
             
    burners_thread = threading.Thread(target=turn_on_burners)

def update_duration_dict() -> None:
    # Remove keys from duration_dict that are not in tag_dict
    for key in list(duration_dict.keys()):
        if key not in tag_dict:
            del duration_dict[key]

    # Add or update keys in duration_dict based on tag_dict
    for key in tag_dict.keys():
        if key in duration_dict:
            duration_dict[key] += 0.1
        else:
            duration_dict[key] = 0.1

def run_server():
    with Server('0.0.0.0', SERVER_PORT, on_data=on_data) as server:
        server.start_server()

class TagDataEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, TagData):
            return dataclasses.asdict(obj)
        return super().default(obj)

def main_loop():
    global tag_dict
    global last_tag_dict
    global delta_dict
    global history_dict
    global avg_dict
    global cart_check_timer
    global hold_in_tub
    global API_initiated
    while True:
        if len(last_tag_dict) == 0:
            last_tag_dict = copy.deepcopy(tag_dict)
            continue
        remove_old_entries()
        calculate_delta_dict()
        update_history()
        update_duration_dict()
        cart = get_stable_items()
        has_cart = len(cart) > 0
        print(cart)                    # PRINT FOR TESTING

        if has_cart and hold_in_tub and not API_initiated and time.time() >= cart_check_timer:
        # if has_cart and time.time() >= cart_check_timer:
        # if has_cart and not API_initiated:
            if not burners_thread.is_alive():
                API_initiated = True
                burners_thread.start()
            else:
                print("Burning...Else case...")
        # print_dicts()
        
        last_tag_dict = copy.deepcopy(tag_dict)
        time.sleep(0.1)

tag_dict: Dict[str, TagData] = {}
last_tag_dict: Dict[str, TagData] = {}
delta_dict: Dict[str, int] = {}
history_dict: Dict[str, List[int]] = {}
avg_dict: Dict[str, int] = {}
duration_dict: Dict[str, float] = {}
last_server_result = {}
hold_in_tub = False
cart_check_timer = 0
API_initiated = False
burners_thread = threading.Thread(target=turn_on_burners)

# Create a thread to run the server
server_thread = threading.Thread(target=run_server)
server_thread.start()

# Start the inactivity check in a separate thread
inactivity_thread = threading.Thread(target=check_inactivity)
# inactivity_thread.daemon = True
inactivity_thread.start()

clients = []
def broadcast(message):
    for client in clients:
        client.send_message(message)

class SimpleEcho(WebSocket):
    def handle(self):
        print(self.data)
        global hold_in_tub
        global cart_check_timer
        global API_initiated
        
        global tag_dict
        global last_tag_dict
        global delta_dict
        global history_dict
        global avg_dict
        global duration_dict

        if self.data == "COLLECTED THE BAG":
            hold_in_tub = False
            cart_check_timer = 0
            API_initiated = False
            
            tag_dict.clear()
            last_tag_dict.clear()
            delta_dict.clear()
            history_dict.clear()
            avg_dict.clear()
            duration_dict.clear()
            
        if self.data == "RESCAN":
            cart_check_timer = 0
            API_initiated = False
            
            tag_dict.clear()
            last_tag_dict.clear()
            delta_dict.clear()
            history_dict.clear()
            avg_dict.clear()
            duration_dict.clear()
            
        if self.data == "CANCEL":
            time.sleep(SLEEP_TIME_ON_CANCEL)
            hold_in_tub = False
            cart_check_timer = 0
            API_initiated = False
            
            tag_dict.clear()
            last_tag_dict.clear()
            delta_dict.clear()
            history_dict.clear()
            avg_dict.clear()
            duration_dict.clear()          
            
            
    def connected(self):
        print(self.address, 'connected')
        for client in clients:
            client.send_message(self.address[0] + u' - connected')
        clients.append(self)

    def handle_close(self):
        clients.remove(self)
        print(self.address, 'closed')
        for client in clients:
            client.send_message(self.address[0] + u' - disconnected')

def run_websocket():
    server = WebSocketServer('0.0.0.0', WEB_SOCKET_PORT, SimpleEcho)
    server.serve_forever()

websocket_thread = threading.Thread(target=run_websocket)
websocket_thread.start()



# Run the main loop in the main thread
print("Starting main loop.")
main_loop()