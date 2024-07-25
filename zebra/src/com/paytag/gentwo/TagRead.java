package com.paytag.gentwo;
import java.time.LocalDate;

public class TagRead {
    public long timeInMs;
    public int count;

    // Constructor without arguments
    public TagRead() {
        // You can initialize the members with default values here if needed.
        // For example, setting date to the current date:
         this.timeInMs = System.currentTimeMillis();
        // And initializing count to a default value like 0:
         this.count = 1;
    }
}