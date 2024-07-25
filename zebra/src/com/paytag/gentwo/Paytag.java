package com.paytag.gentwo;

import com.mot.rfid.api3.*;
import java.util.Hashtable;
import java.util.concurrent.locks.*;


public class Paytag {
	
	Server server = new Server();
	RFIDReader myReader = null;
	public static Hashtable<String,TagRead> tagStore = null;
	public static Hashtable<String,TagRead> cart = null;
	public static long updateCartTimeInMs = 0;
	Thread stateMonitor = null;
	boolean stopThread = false;

    private boolean inventoryComplete = false;
        
        
    private Lock inventoryStopEventLock = new ReentrantLock();
    private Condition inventoryStopCondVar = inventoryStopEventLock.newCondition();
	
	final String APP_NAME = "Paytag_Reader";
	
	public boolean isConnected;
	public boolean isScanning = false;
	public boolean isDone = false;
	
	// To display tag read count
	public long uniqueTags = 0;
	public long totalTags = 0;
	
	private EventsHandler eventsHandler = new EventsHandler();
	

	public int rowId = 0;

	TagData[] myTags = null;

	// 0 - Initialize
	// 1 - Cart Search
	// 2 - Cart Check
	// 3 - Cart Leave
	public int state = 0;
	Long lastestTagReadTimeInMs = null;
			
	public Paytag()
	{

		// Create Reader Object
		myReader = new RFIDReader();
		
		// Hash table to hold the tag data
		tagStore = new Hashtable<String,TagRead>();
		cart = new Hashtable<String,TagRead>();
		
				
		// On Device, connect automatically to the reader
		connectToReader("127.0.0.1", 5084);
		
		

	}
	
	
	public void startMainLoop() throws InterruptedException,InvalidUsageException,OperationFailureException
    {
        System.out.println("..................................................");
        System.out.println("Paytag Zebra RFID Reader");
        System.out.println("..................................................\n\n");
        

        while (!isDone)
        {
            try
            {
//            	System.out.println(state);
                switch (state)
                {
            		// 0 - Initialize
                    case 0:                    	
                    	Initialize();
                        break;
                    // 1 - Cart Search
                    case 1:
                    	CartSearch();
                        break;
                    // 2 - Cart Check
                    case 2:
                    	SendCartToRaspberry();
                        break;
                    // 3 - Cart Leave
                    case 3:
                    	WaitForCartToLeave();
                        break;
                }
                Thread.sleep(100);
            }
            catch (OperationFailureException ex) {
    			postStatusNotification(ex.getStatusDescription(),
    					ex.getVendorMessage());
    		}
            catch (Exception ex)
            {
//            	myReader.Actions.Inventory.stop();
            	System.out.println(ex.getMessage());
            }
        }
        
        System.out.println("..................................................");
        System.out.println("Done main loop");
        System.out.println("..................................................\n\n");
        
    }
	
	
	private void Initialize() throws InvalidUsageException, OperationFailureException {	
		 System.out.println("Initialize");
		 tagStore.clear();
		 cart.clear();
		 lastestTagReadTimeInMs = null;
		 state = 1;
		 myReader.Config.GPO.setPortState(1, GPO_PORT_STATE.TRUE);
	}
	
	private void CartSearch() throws InvalidUsageException, OperationFailureException {
		if (!isScanning ) {
			System.out.println("Reading tags");
			myReader.Actions.Inventory.perform();
			isScanning = true;
		}
		return;
	        // for (String key : tagStore.keySet()) {	        	
	        //     TagRead tagRead = tagStore.get(key);
	        //     boolean tagIsOld = Util.msAgo(tagRead.timeInMs) > 100;
	        //     if (tagIsOld) {
	        //     	tagStore.remove(key);
	        //     	continue;
	        //     }
	            
	        //     if (tagRead.count > 100 && !cart.containsKey(key)) {
	        //     	cart.put(key, tagRead);
	        //     	lastestTagReadTimeInMs = System.currentTimeMillis();	            	
	        //     	Util.printTagReadTable(cart);
	        //     	System.out.println("New item in cart, in 3 seconds the cart will be locked.");
	        //     }
	            
	        //     // This tries to minimize noise by removing tag that are not consistent
	        // }
	        
//	        Util.printTagReadTable(tagStore);
	        
	        // if (lastestTagReadTimeInMs != null && Util.msAgo(lastestTagReadTimeInMs) > 3000) {
	        // 	System.out.println("Cart locked.");
	        // 	myReader.Actions.Inventory.stop();
	        // 	isScanning = false;
	        // 	state = 2;
	        // }
	}
	
	private void SendCartToRaspberry() throws InvalidUsageException, OperationFailureException, InterruptedException {	
		// Send cart to Raspberry
		state = 3;
	}
	
	private void WaitForCartToLeave() throws InterruptedException, InvalidUsageException, OperationFailureException {
		System.out.println("CartLeave");
		System.out.println("Waiting for 2 second for the cart to leave.");
		tagStore.clear();
		if (!isScanning ) {
			myReader.Actions.Inventory.perform();
			isScanning = true;
		}
		Thread.sleep(2000);
		boolean cartLeft = true;
        for (String key : tagStore.keySet()) {
            // Check if this key also exists in cart
            if (cart.containsKey(key)) {
                // Set flag to true if a common key is found
            	cartLeft = false;
                // Optionally break the loop if you only need to know if at least one key exists in both
                break;
            }
        }
		if (cartLeft) {
			System.out.println("Cart left.");
			stopThread = true;
			isScanning = false;
			state = 0;
			myReader.Actions.Inventory.stop();
			Thread.sleep(200);
			isDone = true;
		} else {			
			state = 3;
		}
		
	}
	

	public RFIDReader getMyReader() {
		return myReader;
	}
	
	void updateTags()
	{
		TagDataArray oTagDataArray = myReader.Actions.getReadTagsEx(1000);
		myTags = oTagDataArray.getTags();
		
		if (myTags != null)
		{
			 for (int index = 0; index < oTagDataArray.getLength(); index++) 
			 {
				 TagData tag = myTags[index];
				 String key = tag.getTagID();
				 if (!tagStore.containsKey(key)) {
					tagStore.put(key,new TagRead());
					uniqueTags++;
				  } else {
					  tagStore.get(key).count++;
					  tagStore.get(key).timeInMs = System.currentTimeMillis();
				  }
				 totalTags++;
			 }
			
			for (String key : tagStore.keySet()) {
				TagRead tagRead = tagStore.get(key);
				this.server.send(key + "," + tagRead.count + "," + tagRead.timeInMs);
			}
			tagStore.clear();
			 
				
			
		}
		
	}
	
	void postStatusNotification(String statusMsg, String vendorMsg)
	{
		System.out.println("Status: "+statusMsg+" Vendor Message: "+vendorMsg);
	}
	
    static void postInfoMessage(String msg)
    {
    	System.out.println(msg);
    }
   
    public class EventsHandler implements RfidEventsListener
    {
    	public EventsHandler(){}
    	
    	public void eventReadNotify(RfidReadEvents rre) {
    		updateTags();
		}
    	
    	public void eventStatusNotify(RfidStatusEvents rse) {
    		postInfoMessage(rse.StatusEventData.getStatusEventType().toString());
    		    		
	   	}
    
    }
   
    	
	public boolean connectToReader(String readerHostName, int readerPort)
	{
		
		boolean retVal = false;
		myReader.setHostName(readerHostName);
		myReader.setPort(readerPort);
		
		try {
			myReader.connect();
			myReader.Events.setInventoryStartEvent(true);
			myReader.Events.setInventoryStopEvent(true);
			myReader.Events.setAccessStartEvent(true);
			myReader.Events.setAccessStopEvent(true);
			myReader.Events.setAntennaEvent(true);
			myReader.Events.setGPIEvent(true);
			myReader.Events.setBufferFullEvent(true);
			myReader.Events.setBufferFullWarningEvent(true);
			myReader.Events.setReaderDisconnectEvent(true);
			myReader.Events.setReaderExceptionEvent(true);
			myReader.Events.setTagReadEvent(true);
			myReader.Events.setAttachTagDataWithReadEvent(false);
            
            TagStorageSettings tagStorageSettings = myReader.Config.getTagStorageSettings();
            tagStorageSettings.discardTagsOnInventoryStop(true);
            myReader.Config.setTagStorageSettings(tagStorageSettings);

			myReader.Events.addEventsListener(eventsHandler);
			
			retVal = true;
			isConnected = true;
			postInfoMessage("Connected to reader at " + readerHostName);
			postStatusNotification("Function Succeeded", null);
			myReader.Config.setTraceLevel(TRACE_LEVEL.TRACE_LEVEL_ERROR);
			
			startStateMonitoringThread();
			startMainLoop();
			
			myReader.disconnect();

		} catch (InvalidUsageException ex)
                {
		    postStatusNotification("Parameter Error", ex.getVendorMessage());
		} catch (OperationFailureException ex) {
			postStatusNotification(ex.getStatusDescription(),
					ex.getVendorMessage());
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		return retVal;
		
	}
	
	public static void main(String[] args) throws InterruptedException {
		// TODO Auto-generated method stub
		Paytag rfidBase; 
		rfidBase = new Paytag();
//		Util.post();
	}
	
    public void startStateMonitoringThread() {
        stateMonitor = new Thread(new Runnable() {
            public void run() {
                while (true) {
                	if (stopThread) return;
                    // Access and use the state variable
                    switch (state) {
                        case 0:
                        	// Initialize
                        	blink(new int[] {1});
                            break;
                        case 1:
                        	// Cart Search
                        	blink(new int[] {1, 1, 0, 0, 0, 0, 0, 0, 0, 0});
                            break;
                        case 2:
                        	// Check
                        	blink(new int[] {1, 0, 1, 0, 1, 0, 1, 0, 1, 0});
                            break;
                        case 3:
                        	// Leave
                        	blink(new int[] {1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0});
                            break;
                    }
                }
            }
        });

        stateMonitor.start(); // Start the thread
    }
    
    /**
     * Blinks the GPO based on an array of 0s and 1s.
     * @param pattern An array of integers representing the blink pattern.
     */
    public void blink(int[] pattern) {
        for (int i = 0; i < pattern.length; i++) {
            try {
                if (pattern[i] == 1) {
                	// I dont know why FALSE passes volts in the gpo and TRUE gives out 0 volts...
                    // Turn GPO on
                    myReader.Config.GPO.setPortState(1, GPO_PORT_STATE.FALSE);
                } else {
                    // Turn GPO off
                    myReader.Config.GPO.setPortState(1, GPO_PORT_STATE.TRUE);
                }

                // Sleep for 100 ms
                Thread.sleep(100);
            } catch (Exception e) {
                // Handle exceptions (InvalidUsageException, OperationFailureException, InterruptedException)
                System.out.println("An error occurred during the blink operation: " + e.getMessage());
                break; // Exit the loop if an error occurs
            }
        }
    }
  }
