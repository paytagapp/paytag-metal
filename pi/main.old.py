#!/usr/bin/python

import time
import threading
from Server import Server
from typing import Dict, List
from datetime import datetime, timedelta
from TagData import TagData
import copy
import statistics
import RPi.GPIO as GPIO
import asyncio
from PaytagServer import PaytagServer
from simple_websocket_server import WebSocketServer, WebSocket
import dataclasses, json

def on_data(raw_data, addr):
    # print(f"Custom handler: Received data from {addr}: {data.decode()}")
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
            delta_dict[key] = delta_count
        else:
            # If the key is not in last_tag_dict, you may decide to skip it or handle it differently
            delta_dict[key] = tag_data.count

def update_history() -> None:
    for key, value in delta_dict.items():
        if key in history_dict:
            history_dict[key].append(value)
            # Keep only the last X items
            history_dict[key] = history_dict[key][-20:]
        else:
            history_dict[key] = [value]
            
        avg_dict[key] = int(statistics.median(history_dict[key]))



def remove_old_entries():
    threshold_seconds: int = 2
    current_time = datetime.now()
    keys_to_remove = []
    
    for key, tag_data in tag_dict.items():
        last_read_time = datetime.fromtimestamp(tag_data.last_read)
        if (current_time - last_read_time).total_seconds() > threshold_seconds:
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
            if avg_dict[key] > 2 and duration_dict[key] > 2:
                stable_items.append(key)
    return stable_items

def turn_on_burners():
    global burners_thread
    global last_server_result
    result = PaytagServer.findPaidCartWithItems(get_stable_items())
    last_server_result = result
    if result.get("status") == True:
        # Set the GPIO mode
        GPIO.setmode(GPIO.BCM)
        # Set up GPIO 2 as an output
        GPIO.setup(2, GPIO.OUT, initial=GPIO.LOW)
        GPIO.setup(3, GPIO.OUT, initial=GPIO.LOW)
        
        try:
            # Turn on GPIO 2
            GPIO.output(2, GPIO.HIGH)
            GPIO.output(3, GPIO.HIGH)
            print("GPIO 2 turned on.")
            # Wait for 2 seconds
            time.sleep(2)
            # Turn off GPIO 2
            GPIO.output(2, GPIO.LOW)
            GPIO.output(3, GPIO.LOW)
            print("GPIO 2 turned off.")
        except Exception as e:
            print(f"An error occurred: {e}")
        finally:
            # Clean up GPIO settings
            GPIO.output(2, GPIO.LOW)
            GPIO.output(3, GPIO.LOW)
            print("GPIO cleanup done.")
        
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
    with Server('0.0.0.0', 65432, on_data=on_data) as server:
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
        broadcast(json.dumps({
            "cart": cart,
            "has_cart": has_cart,
            "tag_dict": json.dumps(tag_dict, cls=TagDataEncoder),
            "last_server_result": json.dumps(last_server_result),
        }))

        if has_cart:
            if (not burners_thread.is_alive()):
                print('Starting burners.')
                burners_thread.start()
            else:
                print("Burning...")
        print_dicts()
        
        
        last_tag_dict = copy.deepcopy(tag_dict)
        time.sleep(0.1)

tag_dict: Dict[str, TagData] = {}
last_tag_dict: Dict[str, TagData] = {}
delta_dict: Dict[str, int] = {}
history_dict: Dict[str, List[int]] = {}
avg_dict: Dict[str, int] = {}
duration_dict: Dict[str, float] = {}
last_server_result = {}
burners_thread = threading.Thread(target=turn_on_burners)

# Create a thread to run the server
server_thread = threading.Thread(target=run_server)
server_thread.start()

clients = []
def broadcast(message):
    for client in clients:
        client.send_message(message)
class SimpleEcho(WebSocket):
    def handle(self):
        self.send_message(json.dumps({
            "hello": "world"
        }))
        pass

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
    server = WebSocketServer('0.0.0.0', 8000, SimpleEcho)
    server.serve_forever()

websocket_thread = threading.Thread(target=run_websocket)
websocket_thread.start()



# Run the main loop in the main thread
print("Starting main loop.")
main_loop()
