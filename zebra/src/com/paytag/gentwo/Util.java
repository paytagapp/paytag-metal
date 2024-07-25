package com.paytag.gentwo;

import java.util.Hashtable;
import java.io.BufferedReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.time.LocalDate;
import java.util.Enumeration;

public class Util {

    public static void printTagReadTable(Hashtable<String, TagRead> tagStore) {
        // Print the table header
    	System.out.println();
        System.out.printf("%-20s %-10s %-10s%n", "Key", "Count", "Seconds Ago");

        // Iterate through the hashtable and print each entry
        Enumeration<String> keys = tagStore.keys();
        while (keys.hasMoreElements()) {
            String key = keys.nextElement();
            TagRead tagRead = tagStore.get(key);
            System.out.printf("%-20s %-10d %-10s%n", key, tagRead.count, tagRead.timeInMs);
        }
    }
    
    public static long msAgo(long timeInMillis) {
        long currentTimeInMillis = System.currentTimeMillis();
        return currentTimeInMillis - timeInMillis;
    }
    
    public static float secondsAgo(long timeInMillis) {
        long currentTimeInMillis = System.currentTimeMillis();
        // Calculate the difference in milliseconds and then convert to seconds
        return (currentTimeInMillis - timeInMillis) / 1000f;
    }
    
    public static void post() {
        // Write JSON to the file
        try (FileWriter fileWriter = new FileWriter("./post.json")) {
            fileWriter.write(String.format(
            	    "{" +
        	    	    "\"fields\": {" +
        	    	    "\"name\": {\"stringValue\": \"%s\"}," +
        	    	    "\"email\": {\"stringValue\": \"%s\"}" +
        	    	    "}" +
    	    	    "}", "asd", "a@a.com"));
            System.out.println("Successfully wrote JSON to the file.");
        } catch (IOException e) {
            System.out.println("An error occurred while writing JSON to the file.");
            e.printStackTrace();
            return;
        }

        // Execute the Linux command
        try {
            Process process = Runtime.getRuntime().exec("sh post.sh");
            process.waitFor(); // Wait for the command to complete
            
            // Reading the output of the command
            java.io.BufferedReader reader = new java.io.BufferedReader(new java.io.InputStreamReader(process.getInputStream()));
            String line = "";
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
            }
        } catch (IOException | InterruptedException e) {
            System.out.println("An error occurred while executing the Linux command.");
            e.printStackTrace();
        }

    }

    

}