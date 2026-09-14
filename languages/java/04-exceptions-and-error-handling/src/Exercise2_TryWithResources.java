import java.io.*;
import java.nio.file.*;

public class Exercise2_TryWithResources {
    public static void main(String[] args) {
        System.out.println("=== Traditional resource management ===");
        BufferedReader reader = null;
        try {
            reader = new BufferedReader(new FileReader("nonexistent.txt"));
            String line = reader.readLine();
            System.out.println("Line: " + line);
        } catch (IOException e) {
            System.out.println("IO error (traditional): " + e.getMessage());
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e) {
                    System.out.println("Error closing reader: " + e.getMessage());
                }
            }
        }

        System.out.println();
        System.out.println("=== Try-with-resources ===");
        try (BufferedReader reader2 = new BufferedReader(
                new FileReader("nonexistent.txt"))) {
            String line = reader2.readLine();
            System.out.println("Line: " + line);
        } catch (IOException e) {
            System.out.println("IO error (modern): " + e.getMessage());
        }

        System.out.println();
        System.out.println("=== Multiple resources ===");
        Path tempFile = null;
        try {
            tempFile = Files.write(Files.createTempFile("sample", ".txt"),
                List.of("Line 1", "Line 2", "Line 3").toArray(new String[0]),
                StandardOpenOption.WRITE);

            try (var reader3 = Files.newBufferedReader(tempFile);
                 var writer = Files.newBufferedWriter(
                     Files.createTempFile("output", ".txt"))) {

                String line;
                while ((line = reader3.readLine()) != null) {
                    writer.write(line.toUpperCase());
                    writer.newLine();
                }
                System.out.println("Copied and transformed lines to output file");
            }

            try (var verify = Files.newBufferedReader(tempFile)) {
                System.out.println("Original file content:");
                verify.lines().forEach(System.out::println);
            }

        } catch (IOException e) {
            System.out.println("IO error: " + e.getMessage());
        } finally {
            try {
                if (tempFile != null) Files.deleteIfExists(tempFile);
            } catch (IOException ignored) {}
        }

        System.out.println();
        System.out.println("=== Custom AutoCloseable ===");
        try (MyResource resource = new MyResource("DatabaseConnection")) {
            resource.doWork();
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }

        System.out.println();
        System.out.println("=== Try-with-resources with catch and finally ===");
        try (var r = new MyResource("FileHandler")) {
            r.doWork();
            throw new RuntimeException("Something went wrong!");
        } catch (RuntimeException e) {
            System.out.println("Caught: " + e.getMessage());
        } finally {
            System.out.println("Cleanup complete");
        }
    }

    static class MyResource implements AutoCloseable {
        private final String name;

        public MyResource(String name) {
            this.name = name;
            System.out.println("Opening: " + name);
        }

        public void doWork() {
            System.out.println(name + " is doing work");
        }

        @Override
        public void close() {
            System.out.println("Closing: " + name);
        }
    }
}
