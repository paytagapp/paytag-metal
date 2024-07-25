package com.paytag.gentwo;

import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.Socket;

public class Server {
    static String serverAddress = "paytag1"; // Replace with the server's address
    static int serverPort = 65432; // Replace with the server's port number
    
    Socket socket;
    OutputStream outputStream;
    PrintWriter writer;
    int messageCount = 0; // Counter for the number of messages sent
    
    public Server() {
        connectToServer();
    }

    private void connectToServer() {
        while (true) { // Try to connect until successful
            try {
                this.socket = new Socket(serverAddress, serverPort);
                this.outputStream = this.socket.getOutputStream();
                this.writer = new PrintWriter(outputStream, true);
                System.out.println("Connected to the server.");
                break;
            } catch (Exception e) {
                System.out.println("Failed to connect to the server. Retrying...");
                sleep(1000);
            }
        }
    }

    public void send(String message) {
        // System.out.println("Sending message: " + message);
        try {
            if (this.socket == null || this.outputStream == null || this.writer == null ||
                !socket.isConnected() || socket.isClosed() || socket.isInputShutdown() || socket.isOutputShutdown()) {
                System.out.println("Connection lost. Reconnecting...");
                connectToServer();
            }
            writer.println(message);
            writer.flush();
            messageCount++;
            if (messageCount >= 200) {
                System.out.println("Reconnecting after 200 messages...");
                reconnect();
                messageCount = 0; // Reset the message counter
            }
        } catch (Exception e) {
            System.out.println("Error while sending message. Attempting to reconnect...");
            e.printStackTrace();
            connectToServer();
        }
    }

    private void reconnect() {
        try {
            socket.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        connectToServer();
    }

    private void sleep(int millis) {
        try {
            Thread.sleep(millis); // Sleep for the specified time
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

}