import java.util.concurrent.*;
import java.util.concurrent.atomic.*;
import java.util.*;
import java.util.concurrent.locks.*;

public class Exercise1_Threads {
    public static void main(String[] args) throws InterruptedException {
        System.out.println("Main thread: " + Thread.currentThread().getName());

        Runnable task = () -> {
            System.out.println("Task running on thread: " + Thread.currentThread().getName());
            try {
                Thread.sleep(1000);
                System.out.println("Task finished: " + Thread.currentThread().getName());
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                System.out.println("Task interrupted");
            }
        };

        Thread t1 = new Thread(task, "Worker-1");
        Thread t2 = new Thread(task, "Worker-2");

        System.out.println("Starting threads...");
        t1.start();
        t2.start();

        t1.join();
        t2.join();
        System.out.println("Both threads completed");

        System.out.println();
        System.out.println("=== Shared counter with synchronization ===");
        SharedCounter counter = new SharedCounter();

        Thread incrementer = new Thread(() -> {
            for (int i = 0; i < 1000; i++) { counter.increment(); }
        }, "Incrementer");

        Thread decrementer = new Thread(() -> {
            for (int i = 0; i < 1000; i++) { counter.decrement(); }
        }, "Decrementer");

        incrementer.start();
        decrementer.start();
        incrementer.join();
        decrementer.join();

        System.out.println("Final counter value: " + counter.getCount());

        System.out.println();
        System.out.println("=== Unsynchronized counter (race condition) ===");
        UnsynchronizedCounter badCounter = new UnsynchronizedCounter();

        Thread[] incrementers = new Thread[10];
        Thread[] decrementers = new Thread[10];

        for (int i = 0; i < 10; i++) {
            incrementers[i] = new Thread(() -> {
                for (int j = 0; j < 1000; j++) { badCounter.increment(); }
            });
            decrementers[i] = new Thread(() -> {
                for (int j = 0; j < 1000; j++) { badCounter.decrement(); }
            });
            incrementers[i].start();
            decrementers[i].start();
        }

        for (Thread t : incrementers) t.join();
        for (Thread t : decrementers) t.join();

        System.out.println("Unsynchronized counter: " + badCounter.getCount() +
            " (expected 0, often not zero due to race condition)");
    }
}

class SharedCounter {
    private int count = 0;
    public synchronized void increment() { count++; }
    public synchronized void decrement() { count--; }
    public synchronized int getCount() { return count; }
}

class UnsynchronizedCounter {
    private int count = 0;
    public void increment() { count++; }
    public void decrement() { count--; }
    public int getCount() { return count; }
}
