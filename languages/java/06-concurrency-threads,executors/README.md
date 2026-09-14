# Project 06: Concurrency with Threads and Executors — Java

**Difficulty:** advanced  
**Prerequisites:** Project 05 (Testing with JUnit and Mockito)

## Goals

- Create and manage threads with `Thread` and `Runnable`
- Use `ExecutorService`, `ThreadPoolExecutor`, and `Executors` factory
- Understand `Callable<V>` and `Future<V>` for async results
- Use `CompletableFuture` for async composition (Java 8+)
- Coordinate threads with `synchronized`, `wait/notify`, `Lock`, `Semaphore`
- Use concurrent collections: `ConcurrentHashMap`, `CopyOnWriteArrayList`, `BlockingQueue`
- Understand thread safety, atomic variables, and the producer-consumer pattern

## Concepts

- **Thread** — lightweight unit of execution; `new Thread(Runnable).start()`
- **Runnable** — functional interface with `run()` (no return, no checked exceptions)
- **Callable<V>** — returns `V`, can throw exception
- **ExecutorService** — thread pool managing lifecycle of threads
- **Future<V>** — placeholder for async result; `get()` blocks
- **CompletableFuture<V>** — non-blocking async pipeline (Java 8+)
- **synchronized** — intrinsic lock on object/method
- **volatile** — guarantees visibility across threads
- **Atomic variables** — `AtomicInteger`, `AtomicReference` — lock-free thread safety
- **BlockingQueue** — thread-safe queue with blocking put/take
- **CountDownLatch** — wait for N events
- **CyclicBarrier** — rendezvous N threads at a point
- **Semaphore** — permit-based access control
- **Producer-Consumer** — pattern using BlockingQueue

## Exercises

### Exercise 1: Thread Basics — Runnable and Thread

Create `src/Exercise1_Threads.java`:

```java
import java.util.concurrent.*;

public class Exercise1_Threads {
    public static void main(String[] args) throws InterruptedException {
        System.out.println("Main thread: " + Thread.currentThread().getName());

        // Thread via Runnable
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

        // Join — wait for threads to finish
        t1.join();
        t2.join();
        System.out.println("Both threads completed");

        // Thread with shared counter
        System.out.println("\n=== Shared counter with synchronization ===");
        SharedCounter counter = new SharedCounter();

        Thread incrementer = new Thread(() -> {
            for (int i = 0; i < 1000; i++) {
                counter.increment();
            }
        }, "Incrementer");

        Thread decrementer = new Thread(() -> {
            for (int i = 0; i < 1000; i++) {
                counter.decrement();
            }
        }, "Decrementer");

        incrementer.start();
        decrementer.start();
        incrementer.join();
        decrementer.join();

        System.out.println("Final counter value: " + counter.getCount());

        // Without synchronization (race condition demo)
        System.out.println("\n=== Unsynchronized counter (race condition) ===");
        UnsynchronizedCounter badCounter = new UnsynchronizedCounter();

        Thread[] incrementers = new Thread[10];
        Thread[] decrementers = new Thread[10];

        for (int i = 0; i < 10; i++) {
            incrementers[i] = new Thread(() -> {
                for (int j = 0; j < 1000; j++) {
                    badCounter.increment();
                }
            });
            decrementers[i] = new Thread(() -> {
                for (int j = 0; j < 1000; j++) {
                    badCounter.decrement();
                }
            });
            incrementers[i].start();
            decrementers[i].start();
        }

        for (Thread t : incrementers) t.join();
        for (Thread t : decrementers) t.join();

        // Without synchronization, result is often NOT zero
        System.out.println("Unsynchronized counter: " + badCounter.getCount() +
            " (expected 0, often not zero due to race condition)");
    }
}

class SharedCounter {
    private int count = 0;

    public synchronized void increment() {
        count++;
    }

    public synchronized void decrement() {
        count--;
    }

    public synchronized int getCount() {
        return count;
    }
}

class UnsynchronizedCounter {
    private int count = 0;

    public void increment() {
        count++;  // Not atomic — read, modify, write
    }

    public void decrement() {
        count--;
    }

    public int getCount() {
        return count;
    }
}
""")

write_file(os.path.join(p06, "src", "Exercise2_ExecutorService.java"), """import java.util.concurrent.*;
import java.util.*;

public class Exercise2_ExecutorService {
    public static void main(String[] args) {
        // Fixed thread pool — fixed number of threads
        System.out.println("=== Fixed thread pool (4 threads) ===");
        ExecutorService fixedPool = Executors.newFixedThreadPool(4);

        for (int i = 0; i < 8; i++) {
            final int taskId = i;
            fixedPool.submit(() -> {
                System.out.println("Task " + taskId + " on " +
                    Thread.currentThread().getName());
                try {
                    Thread.sleep(500);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                }
                System.out.println("Task " + taskId + " done");
            });
        }

        // Shutdown — graceful
        fixedPool.shutdown();
        try {
            if (!fixedPool.awaitTermination(5, TimeUnit.SECONDS)) {
                fixedPool.shutdownNow();
            }
        } catch (InterruptedException e) {
            fixedPool.shutdownNow();
        }

        // Cached thread pool — creates threads as needed
        System.out.println("\n=== Cached thread pool ===");
        ExecutorService cachedPool = Executors.newCachedThreadPool();
        CountDownLatch latch = new CountDownLatch(5);

        for (int i = 0; i < 5; i++) {
            final int taskId = i;
            cachedPool.submit(() -> {
                System.out.println("Cached task " + taskId + " on " +
                    Thread.currentThread().getName());
                latch.countDown();
            });
        }

        try {
            latch.await();  // Wait for all tasks
            System.out.println("All cached tasks done");
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        cachedPool.shutdown();

        // Single thread executor — sequential execution
        System.out.println("\n=== Single thread executor ===");
        ExecutorService singleThread = Executors.newSingleThreadExecutor();
        AtomicInteger seq = new AtomicInteger(0);

        for (int i = 0; i < 5; i++) {
            singleThread.submit(() -> {
                int val = seq.incrementAndGet();
                System.out.println("Sequential task: " + val +
                    " on " + Thread.currentThread().getName());
                try {
                    Thread.sleep(200);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                }
            });
        }

        singleThread.shutdown();
        try {
            singleThread.awaitTermination(3, TimeUnit.SECONDS);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        // Work stealing pool — ForkJoinPool.commonPool()
        System.out.println("\n=== Work-stealing pool (common) ===");
        ForkJoinPool commonPool = ForkJoinPool.commonPool();
        System.out.println("Common pool parallelism: " +
            commonPool.getParallelism());

        CountDownLatch workLatch = new CountDownLatch(10);
        for (int i = 0; i < 10; i++) {
            commonPool.submit(() -> {
                System.out.println("Work-stealing task on " +
                    Thread.currentThread().getName());
                workLatch.countDown();
            });
        }

        try {
            workLatch.await();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        // Custom ThreadPoolExecutor
        System.out.println("\n=== Custom ThreadPoolExecutor ===");
        ThreadPoolExecutor custom = new ThreadPoolExecutor(
            2,          // core pool size
            4,          // max pool size
            60,         // keep-alive time
            TimeUnit.SECONDS,
            new LinkedBlockingQueue<>(10),  // work queue
            new ThreadPoolExecutor.CallerRunsPolicy()  // saturation policy
        );

        for (int i = 0; i < 10; i++) {
            final int taskId = i;
            custom.submit(() -> {
                System.out.println("Custom task " + taskId + " on " +
                    Thread.currentThread().getName());
                try {
                    Thread.sleep(300);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                }
            });
        }

        custom.shutdown();
        try {
            custom.awaitTermination(5, TimeUnit.SECONDS);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}
""")

write_file(os.path.join(p06, "src", "Exercise3_FuturesAndCallables.java"), """import java.util.concurrent.*;
import java.util.*;
import java.time.Duration;

public class Exercise3_FuturesAndCallables {
    public static void main(String[] args) {
        // Callable + Future for async computation with result
        System.out.println("=== Callable + Future ===");
        ExecutorService executor = Executors.newFixedThreadPool(2);

        Callable<Integer> squareTask = () -> {
            System.out.println("Computing square on " +
                Thread.currentThread().getName());
            Thread.sleep(1000);  // Simulate work
            return 42 * 42;
        };

        Future<Integer> future = executor.submit(squareTask);

        System.out.println("Submitted task, doing other work...");

        try {
            // get() blocks until result is ready
            Integer result = future.get(3, TimeUnit.SECONDS);
            System.out.println("Future result: " + result);
        } catch (TimeoutException e) {
            System.out.println("Timed out!");
            future.cancel(true);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            System.out.println("Interrupted!");
        } catch (ExecutionException e) {
            System.out.println("Task failed: " + e.getCause());
        }

        // Multiple futures with invokeAll
        System.out.println("\n=== invokeAll — multiple tasks ===");
        List<Callable<String>> tasks = List.of(
            () -> { Thread.sleep(500); return "Task A done"; },
            () -> { Thread.sleep(300); return "Task B done"; },
            () -> { Thread.sleep(700); return "Task C done"; }
        );

        try {
            List<Future<String>> results = executor.invokeAll(tasks, 2, TimeUnit.SECONDS);

            for (int i = 0; i < results.size(); i++) {
                Future<String> r = results.get(i);
                if (r.isDone()) {
                    System.out.println("Task " + (i+1) + ": " + r.getNow("Timed out"));
                } else {
                    System.out.println("Task " + (i+1) + ": Still running");
                }
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        // invokeAny — returns first successful result
        System.out.println("\n=== invokeAny — first to finish ===");
        List<Callable<String>> raceTasks = List.of(
            () -> {
                Thread.sleep(800);
                return "Slow winner";
            },
            () -> {
                Thread.sleep(400);
                return "Fast winner";
            },
            () -> {
                Thread.sleep(600);
                return "Medium winner";
            }
        );

        try {
            String winner = executor.invokeAny(raceTasks, 2, TimeUnit.SECONDS);
            System.out.println("Winner: " + winner);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        } catch (ExecutionException e) {
            System.out.println("All failed: " + e.getCause());
        }

        // isDone and isCancelled checks
        System.out.println("\n=== Future states ===");
        Future<String> statusFuture = executor.submit(() -> {
            Thread.sleep(500);
            return "Done";
        });

        System.out.println("Is done? " + statusFuture.isDone());
        System.out.println("Is cancelled? " + statusFuture.isCancelled());

        try {
            Thread.sleep(600);  // Wait for completion
            System.out.println("After sleep — Is done? " + statusFuture.isDone());
            System.out.println("Result: " + statusFuture.getNow("Not ready"));
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        executor.shutdown();
        try {
            executor.awaitTermination(3, TimeUnit.SECONDS);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}
""")

write_file(os.path.join(p06, "src", "Exercise4_CompletableFuture.java"), """import java.util.concurrent.*;
import java.util.function.*;
import java.util.*;
import java.time.Duration;

public class Exercise4_CompletableFuture {
    public static void main(String[] args) {
        // Manual completion
        System.out.println("=== Manual completion ===");
        CompletableFuture<String> manual = new CompletableFuture<>();

        new Thread(() -> {
            try {
                Thread.sleep(500);
                manual.complete("Result from async thread");
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }).start();

        System.out.println("Waiting for result...");
        String result = manual.join();  // Blocks
        System.out.println("Got: " + result);

        // SupplyAsync — async with supplier
        System.out.println("\n=== supplyAsync ===");
        CompletableFuture<Integer> future = CompletableFuture.supplyAsync(() -> {
            System.out.println("Computing on " + Thread.currentThread().getName());
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
            return 42;
        });

        // thenApply — transform result
        future.thenApply(value -> value * 2)
              .thenAccept(System.out::println);  // Prints 84

        future.join();  // Wait

        // thenAccept — consume result
        System.out.println("\n=== thenAccept ===");
        CompletableFuture.supplyAsync(() -> "Hello")
            .thenAccept(System.out::println);

        // thenRun — run regardless of result
        System.out.println("\n=== thenRun ===");
        CompletableFuture.supplyAsync(() -> {
            try { Thread.sleep(200); } catch (InterruptedException e) { Thread.currentThread().interrupt(); }
            return "done";
        }).thenRun(() -> System.out.println("Task completed (thenRun)"));

        // Chaining with thenCompose (flatMap)
        System.out.println("\n=== thenCompose (async chaining) ===");
        CompletableFuture<String> chained = CompletableFuture.supplyAsync(() -> "user-id-123")
            .thenCompose(id -> CompletableFuture.supplyAsync(() -> "User data for " + id));

        System.out.println("Chained: " + chained.join());

        // Combining two futures with thenCombine
        System.out.println("\n=== thenCombine ===");
        CompletableFuture<Integer> f1 = CompletableFuture.supplyAsync(() -> {
            try { Thread.sleep(300); } catch (InterruptedException e) { Thread.currentThread().interrupt(); }
            return 10;
        });
        CompletableFuture<Integer> f2 = CompletableFuture.supplyAsync(() -> {
            try { Thread.sleep(400); } catch (InterruptedException e) { Thread.currentThread().interrupt(); }
            return 20;
        });

        CompletableFuture<Integer> combined = f1.thenCombine(f2, (a, b) -> a + b);
        System.out.println("Combined (10 + 20): " + combined.join());

        // allOf / anyOf — wait for multiple
        System.out.println("\n=== allOf / anyOf ===");
        CompletableFuture<String> cf1 = CompletableFuture.supplyAsync(() -> {
            try { Thread.sleep(200); } catch (InterruptedException e) { Thread.currentThread().interrupt(); }
            return "A";
        });
        CompletableFuture<String> cf2 = CompletableFuture.supplyAsync(() -> {
            try { Thread.sleep(100); } catch (InterruptedException e) { Thread.currentThread().interrupt(); }
            return "B";
        });
        CompletableFuture<String> cf3 = CompletableFuture.supplyAsync(() -> {
            try { Thread.sleep(300); } catch (InterruptedException e) { Thread.currentThread().interrupt(); }
            return "C";
        });

        CompletableFuture<Void> all = CompletableFuture.allOf(cf1, cf2, cf3);
        all.join();
        System.out.println("All completed");

        CompletableFuture<Object> any = CompletableFuture.anyOf(cf1, cf2, cf3);
        System.out.println("Any completed first: " + any.join());

        // Exception handling with exceptionally and handle
        System.out.println("\n=== Exception handling ===");
        CompletableFuture<Integer> errFuture = CompletableFuture.supplyAsync(() -> {
            throw new RuntimeException("Something went wrong");
        });

        Integer recovered = errFuture
            .exceptionally(ex -> {
                System.out.println("Exception: " + ex.getMessage());
                return -1;  // Default value
            })
            .join();

        System.out.println("Recovered value: " + recovered);

        // handle — handles both success and failure
        String handled = CompletableFuture.supplyAsync(() -> {
            if (Math.random() > 0.5) {
                throw new RuntimeException("Random failure");
            }
            return "Success";
        }).handle((result, ex) -> {
            if (ex != null) {
                return "Handled error: " + ex.getMessage();
            }
            return result;
        }).join();

        System.out.println("Handled: " + handled);

        // Complete exceptionally
        System.out.println("\n=== completeExceptionally ===");
        CompletableFuture<String> cf = new CompletableFuture<>();
        cf.completeExceptionally(new RuntimeException("Manual failure"));

        try {
            cf.join();
        } catch (CompletionException e) {
            System.out.println("Caught: " + e.getCause().getMessage());
        }

        // Real-world pattern: parallel API calls
        System.out.println("\n=== Parallel API calls pattern ===");
        CompletableFuture<Double> priceFuture = CompletableFuture.supplyAsync(() -> {
            try { Thread.sleep(200); } catch (InterruptedException e) { Thread.currentThread().interrupt(); }
            return 99.99;
        });
        CompletableFuture<Double> taxFuture = CompletableFuture.supplyAsync(() -> {
            try { Thread.sleep(150); } catch (InterruptedException e) { Thread.currentThread().interrupt(); }
            return 8.50;
        });
        CompletableFuture<String> shippingFuture = CompletableFuture.supplyAsync(() -> {
            try { Thread.sleep(250); } catch (InterruptedException e) { Thread.currentThread().interrupt(); }
            return "Free shipping";
        });

        CompletableFuture<OrderSummary> orderFuture = priceFuture.thenCombine(
            taxFuture, (price, tax) -> new OrderSummary(price, tax))
            .thenCombine(shippingFuture, (summary, shipping) ->
                new OrderSummary(summary.price(), summary.tax(), shipping));

        OrderSummary summary = orderFuture.join();
        System.out.println("Order: $" + summary.price() +
            " + $" + summary.tax() + " tax, " + summary.shipping());
    }

    record OrderSummary(double price, double tax, String shipping) {}
}
""")

write_file(os.path.join(p06, "src", "Exercise5_ThreadSafety.java"), """import java.util.concurrent.*;
import java.util.concurrent.atomic.*;
import java.util.*;
import java.util.concurrent.locks.*;

public class Exercise5_ThreadSafety {
    public static void main(String[] args) throws InterruptedException {
        // AtomicInteger — lock-free thread safety
        System.out.println("=== AtomicInteger ===");
        AtomicInteger counter = new AtomicInteger(0);

        ExecutorService executor = Executors.newFixedThreadPool(4);
        CountDownLatch latch = new CountDownLatch(100);

        for (int i = 0; i < 100; i++) {
            executor.submit(() -> {
                counter.incrementAndGet();
                latch.countDown();
            });
        }

        latch.await();
        System.out.println("Atomic counter: " + counter.get() + " (expected 100)");
        executor.shutdown();

        // AtomicReference
        System.out.println("\n=== AtomicReference ===");
        AtomicReference<String> ref = new AtomicReference<>("initial");

        AtomicInteger swaps = new AtomicInteger(0);
        CountDownLatch swapLatch = new CountDownLatch(1000);

        ExecutorService swapExecutor = Executors.newFixedThreadPool(4);
        for (int i = 0; i < 1000; i++) {
            swapExecutor.submit(() -> {
                ref.compareAndSet("a", "b");
                ref.compareAndSet("b", "a");
                swaps.incrementAndGet();
                swapLatch.countDown();
            });
        }
        swapLatch.await();
        System.out.println("Final atomic reference: " + ref.get());
        System.out.println("Swaps performed: " + swaps.get());
        swapExecutor.shutdown();

        // Lock — ReentrantLock
        System.out.println("\n=== ReentrantLock ===");
        ReentrantLock lock = new ReentrantLock();
        int sharedValue = 0;

        ExecutorService lockExecutor = Executors.newFixedThreadPool(4);
        CountDownLatch lockLatch = new CountDownLatch(100);

        for (int i = 0; i < 100; i++) {
            lockExecutor.submit(() -> {
                lock.lock();
                try {
                    sharedValue++;
                } finally {
                    lock.unlock();  // Always unlock in finally
                }
                lockLatch.countDown();
            });
        }
        lockLatch.await();
        System.out.println("Shared value with lock: " + sharedValue + " (expected 100)");
        lockExecutor.shutdown();

        // ReadWriteLock — multiple readers, single writer
        System.out.println("\n=== ReadWriteLock ===");
        ReadWriteLock rwLock = new ReentrantReadWriteLock();
        List<String> data = Collections.synchronizedList(new ArrayList<>());

        ExecutorService rwExecutor = Executors.newFixedThreadPool(6);

        // Writers
        for (int i = 0; i < 2; i++) {
            final int writerId = i;
            rwExecutor.submit(() -> {
                rwLock.writeLock().lock();
                try {
                    for (int j = 0; j < 5; j++) {
                        data.add("Writer-" + writerId + "-" + j);
                        System.out.println("Writer " + writerId + " added item");
                        Thread.sleep(50);
                    }
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                } finally {
                    rwLock.writeLock().unlock();
                }
            });
        }

        // Readers
        CountDownLatch readerLatch = new CountDownLatch(4);
        for (int i = 0; i < 4; i++) {
            rwExecutor.submit(() -> {
                rwLock.readLock().lock();
                try {
                    System.out.println("Reader reading " + data.size() + " items: " + data);
                    Thread.sleep(100);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                } finally {
                    rwLock.readLock().unlock();
                    readerLatch.countDown();
                }
            });
        }

        readerLatch.await();
        rwExecutor.shutdown();

        // Semaphore — permit-based access
        System.out.println("\n=== Semaphore ===");
        Semaphore semaphore = new Semaphore(3);  // Only 3 concurrent

        ExecutorService semExecutor = Executors.newFixedThreadPool(10);
        CountDownLatch semLatch = new CountDownLatch(10);

        for (int i = 0; i < 10; i++) {
            final int taskId = i;
            semExecutor.submit(() -> {
                try {
                    semaphore.acquire();  // Acquire permit
                    System.out.println("Task " + taskId + " acquired permit, " +
                        semaphore.availablePermits() + " remaining");
                    Thread.sleep(200);
                    semaphore.release();  // Release permit
                    System.out.println("Task " + taskId + " released permit");
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                }
                semLatch.countDown();
            });
        }
        semLatch.await();
        System.out.println("All semaphore tasks done");
        semExecutor.shutdown();

        // BlockingQueue — Producer-Consumer pattern
        System.out.println("\n=== BlockingQueue — Producer-Consumer ===");
        BlockingQueue<String> queue = new LinkedBlockingQueue<>(5);

        ExecutorService pcExecutor = Executors.newFixedThreadPool(4);

        // Producer
        pcExecutor.submit(() -> {
            for (int i = 0; i < 10; i++) {
                try {
                    queue.put("Item-" + i);  // Blocks if queue full
                    System.out.println("Produced: Item-" + i);
                    Thread.sleep(100);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                }
            }
            queue.put("DONE");  // Sentinel
        });

        // Consumers
        CountDownLatch consumerLatch = new CountDownLatch(3);
        for (int i = 0; i < 3; i++) {
            final int consumerId = i;
            pcExecutor.submit(() -> {
                try {
                    while (true) {
                        String item = queue.take();  // Blocks if queue empty
                        if ("DONE".equals(item)) break;
                        System.out.println("Consumer " + consumerId +
                            " consumed: " + item);
                    }
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                }
                consumerLatch.countDown();
            });
        }

        consumerLatch.await();
        System.out.println("All consumers done");
        pcExecutor.shutdown();
    }
}
""")

write_file(os.path.join(p06, "src", "Exercise6_ConcurrentCollections.java"), """import java.util.concurrent.*;
import java.util.*;
import java.util.concurrent.atomic.*;

public class Exercise6_ConcurrentCollections {
    public static void main(String[] args) {
        // ConcurrentHashMap — thread-safe map
        System.out.println("=== ConcurrentHashMap ===");
        ConcurrentHashMap<String, Integer> map = new ConcurrentHashMap<>();

        ExecutorService executor = Executors.newFixedThreadPool(4);
        CountDownLatch latch = new CountDownLatch(100);

        for (int i = 0; i < 100; i++) {
            final int id = i;
            executor.submit(() -> {
                map.merge("key-" + (id % 10), 1, Integer::sum);
                latch.countDown();
            });
        }

        latch.await();
        System.out.println("ConcurrentHashMap contents:");
        map.forEach((k, v) -> System.out.println("  " + k + ": " + v));
        System.out.println("Total count: " + map.values().stream().mapToInt(Integer::intValue).sum());
        executor.shutdown();

        // CopyOnWriteArrayList — thread-safe list for read-heavy workloads
        System.out.println("\n=== CopyOnWriteArrayList ===");
        CopyOnWriteArrayList<String> cowList = new CopyOnWriteArrayList<>();

        cowList.add("item1");
        cowList.add("item2");
        cowList.add("item3");

        // Safe to iterate while modifying
        for (String item : cowList) {
            System.out.println("  " + item);
            if (cowList.size() < 10) {
                cowList.add("new-" + cowList.size());  // Safe iteration
            }
        }

        System.out.println("Final size: " + cowList.size());

        // ConcurrentLinkedQueue — non-blocking queue
        System.out.println("\n=== ConcurrentLinkedQueue ===");
        ConcurrentLinkedQueue<Integer> queue = new ConcurrentLinkedQueue<>();

        ExecutorService queueExecutor = Executors.newFixedThreadPool(4);
        CountDownLatch queueLatch = new CountDownLatch(50);

        for (int i = 0; i < 50; i++) {
            final int val = i;
            queueExecutor.submit(() -> {
                queue.offer(val);
                queueLatch.countDown();
            });
        }

        queueLatch.await();

        // Drain to list
        List<Integer> drained = new ArrayList<>();
        queue.drainTo(drained);
        System.out.println("Queue size: " + drained.size());
        System.out.println("Contains all 0-49: " +
            drained.containsAll(IntStream.range(0, 50).boxed().toList()));
        queueExecutor.shutdown();

        // ConcurrentLinkedDeque — double-ended
        System.out.println("\n=== ConcurrentLinkedDeque ===");
        ConcurrentLinkedDeque<String> deque = new ConcurrentLinkedDeque<>();

        deque.push("first");
        deque.push("second");
        deque.offerLast("third");
        deque.offerLast("fourth");

        System.out.println("Deque elements:");
        deque.forEach(System.out::println);

        // SynchronousQueue — handoff queue (put blocks until take)
        System.out.println("\n=== SynchronousQueue ===");
        SynchronousQueue<String> syncQueue = new SynchronousQueue<>();

        ExecutorService syncExecutor = Executors.newFixedThreadPool(2);
        syncExecutor.submit(() -> {
            try {
                System.out.println("Producer: putting item...");
                syncQueue.put("handoff-item");
                System.out.println("Producer: item taken");
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        });

        syncExecutor.submit(() -> {
            try {
                Thread.sleep(500);  // Delay to let producer block
                System.out.println("Consumer: taking item...");
                String item = syncQueue.take();
                System.out.println("Consumer: got " + item);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        });

        try {
            Thread.sleep(1500);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        syncExecutor.shutdown();
    }
}
""")

write_file(os.path.join(p06, "build.gradle"), """plugins {
    id 'java'
}

java {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}

repositories {
    mavenCentral()
}

dependencies {
    // No external dependencies for concurrency exercises
}

tasks.withType(JavaCompile) {
    options.encoding = 'UTF-8'
}
""")

print("Project 06 done")
