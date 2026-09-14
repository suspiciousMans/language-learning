// Exercise 1: Stream Fundamentals — FileStream, MemoryStream, CopyTo, Position, Seek
// Covers: reading/writing files with FileStream, using MemoryStream for in-memory
//         buffers, Stream.CopyTo, Position/Seek, stream lifecycle and disposal

using System;
using System.IO;
using System.Text;

class Program
{
    static void Main()
    {
        // Create a working directory for this exercise
        var workDir = Path.Combine(Path.GetTempPath(), "csharp-07-io-exercises");
        Directory.CreateDirectory(workDir);

        Console.WriteLine($"Working directory: {workDir}\n");

        // --- Part 1: Write a file with FileStream ---
        var textPath = Path.Combine(workDir, "example.txt");
        WriteTextFile(textPath, "Hello from FileStream!\nThis is line 2.\nThis is line 3.");

        Console.WriteLine("=== Reading with FileStream (Read call in a loop) ===");
        ReadWithFileStream(textPath);

        Console.WriteLine("\n=== Reading with StreamReader (higher-level) ===");
        ReadWithStreamReader(textPath);

        // --- Part 2: Binary data with FileStream ---
        var binPath = Path.Combine(workDir, "data.bin");
        WriteBinaryFile(binPath);

        Console.WriteLine("\n=== Reading binary data back ===");
        ReadBinaryFile(binPath);

        // --- Part 3: CopyTo and concatenation ---
        var copyFrom = Path.Combine(workDir, "source.txt");
        var copyTo = Path.Combine(workDir, "destination.txt");
        WriteTextFile(copyFrom, "This content will be copied.\nUsing Stream.CopyTo.\n");

        Console.WriteLine("\n=== Stream.CopyTo example ===");
        CopyFile(copyFrom, copyTo);
        Console.WriteLine($"Copied {copyFrom} -> {copyTo}");
        Console.WriteLine("Destination contents:");
        Console.WriteLine(File.ReadAllText(copyTo));

        // --- Part 4: MemoryStream for in-memory buffering ---
        Console.WriteLine("\n=== MemoryStream example ===");
        UseMemoryStream();

        // --- Part 5: Seek and Position ---
        Console.WriteLine("\n=== Seek and Position ===");
        DemonstrateSeek(textPath);

        // Clean up
        Console.WriteLine($"\nCleaned up working directory.");
        try { Directory.Delete(workDir, true); } catch { }
    }

    /// <summary>
    /// Writes text to a file using a FileStream and a StreamWriter.
    /// Demonstrates explicit stream creation + using block for disposal.
    /// </summary>
    static void WriteTextFile(string path, string content)
    {
        // FileStream gives low-level control; StreamWriter adds text encoding
        using var stream = new FileStream(path, FileMode.Create, FileAccess.Write, FileShare.None);
        using var writer = new StreamWriter(stream, Encoding.UTF8);
        writer.Write(content);
        // writer.Close() / stream.Close() happen via Dispose in the using block
    }

    /// <summary>
    /// Reads a text file byte-by-byte using FileStream.Read in a loop.
    /// Shows manual buffer handling, position tracking, and encoding.
    /// </summary>
    static void ReadWithFileStream(string path)
    {
        using var stream = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.Read);
        var buffer = new byte[128];
        int totalRead = 0;

        while (true)
        {
            int bytesRead = stream.Read(buffer, 0, buffer.Length);
            if (bytesRead == 0) break; // EOF

            totalRead += bytesRead;
            string chunk = Encoding.UTF8.GetString(buffer, 0, bytesRead);
            Console.Write(chunk);
        }

        Console.WriteLine($"\n--- Total bytes read: {totalRead}, final Position: {stream.Position} ---");
    }

    /// <summary>
    /// Reads a text file using StreamReader — simpler, line-oriented, with encoding.
    /// </summary>
    static void ReadWithStreamReader(string path)
    {
        using var reader = new StreamReader(path, Encoding.UTF8);
        string? line;
        while ((line = reader.ReadLine()) != null)
        {
            Console.WriteLine($"[line] {line}");
        }
    }

    /// <summary>
    /// Writes structured binary data (primitives and a string) to a file.
    /// Demonstrates WriteByte, Write* primitives, and encoding a string to bytes.
    /// </summary>
    static void WriteBinaryFile(string path)
    {
        using var stream = new FileStream(path, FileMode.Create, FileAccess.Write);
        using var writer = new BinaryWriter(stream, Encoding.UTF8);

        writer.Write((byte)0x55);          // signature byte
        writer.Write((int)42);             // an integer
        writer.Write((double)3.14159);      // a double
        writer.Write("Hello binary world"); // a string (length-prefixed by BinaryWriter)

        Console.WriteLine("Wrote binary file with signature + int + double + string.");
    }

    /// <summary>
    /// Reads back the binary file written by WriteBinaryFile.
    /// Demonstrates BinaryReader and matching Read* calls.
    /// </summary>
    static void ReadBinaryFile(string path)
    {
        using var stream = new FileStream(path, FileMode.Open, FileAccess.Read);
        using var reader = new BinaryReader(stream, Encoding.UTF8);

        byte sig = reader.ReadByte();
        int number = reader.ReadInt32();
        double pi = reader.ReadDouble();
        string text = reader.ReadString();

        Console.WriteLine($"Signature: 0x{sig:X2}");
        Console.WriteLine($"Integer: {number}");
        Console.WriteLine($"Double: {pi}");
        Console.WriteLine($"String: \"{text}\"");
    }

    /// <summary>
    /// Copies a file using Stream.CopyTo — the simplest way to copy stream contents.
    /// </summary>
    static void CopyFile(string sourcePath, string destPath)
    {
        using var source = new FileStream(sourcePath, FileMode.Open, FileAccess.Read);
        using var dest = new FileStream(destPath, FileMode.Create, FileAccess.Write);
        source.CopyTo(dest); // Copies all bytes from source to dest
    }

    /// <summary>
    /// Demonstrates MemoryStream — an in-memory stream backed by a byte array.
    /// Useful for buffering, prototyping, and testing without touching disk.
    /// </summary>
    static void UseMemoryStream()
    {
        using var ms = new MemoryStream();

        // Write data to the memory stream
        byte[] helloBytes = Encoding.UTF8.GetBytes("Hello ");
        ms.Write(helloBytes, 0, helloBytes.Length);

        byte[] worldBytes = Encoding.UTF8.GetBytes("MemoryStream!");
        ms.Write(worldBytes, 0, worldBytes.Length);

        Console.WriteLine($"MemoryStream Position after writes: {ms.Position}");
        Console.WriteLine($"MemoryStream Length: {ms.Length}");

        // Reset position to read from the beginning
        ms.Position = 0;
        using var reader = new StreamReader(ms, Encoding.UTF8);
        string content = reader.ReadToEnd();
        Console.WriteLine($"Read back: \"{content}\"");

        // ToArray gives a copy of the underlying buffer
        byte[] snapshot = ms.ToArray();
        Console.WriteLine($"ToArray() length: {snapshot.Length} bytes");
    }

    /// <summary>
    /// Demonstrates Seek and Position — random access within a stream.
    /// </summary>
    static void DemonstrateSeek(string path)
    {
        using var stream = new FileStream(path, FileMode.Open, FileAccess.ReadWrite);
        long originalLength = stream.Length;

        Console.WriteLine($"File length: {originalLength} bytes");
        Console.WriteLine($"Initial Position: {stream.Position}");

        // Read first 5 bytes
        byte[] start = new byte[5];
        stream.Read(start, 0, 5);
        Console.WriteLine($"First 5 bytes: {Encoding.UTF8.GetString(start)}");
        Console.WriteLine($"Position after read: {stream.Position}");

        // Seek back to start
        stream.Seek(0, SeekOrigin.Begin);
        Console.WriteLine($"Position after Seek(0, Begin): {stream.Position}");

        // Seek relative to current position
        stream.Seek(2, SeekOrigin.Current);
        Console.WriteLine($"Position after Seek(2, Current): {stream.Position}");

        // Seek from end
        stream.Seek(-3, SeekOrigin.End);
        Console.WriteLine($"Position after Seek(-3, End): {stream.Position}");

        // Read final bytes
        byte[] end = new byte[3];
        stream.Read(end, 0, 3);
        Console.WriteLine($"Last 3 bytes (from end): {Encoding.UTF8.GetString(end)}");

        // Demonstrate Position setter
        stream.Position = 0;
        Console.WriteLine($"Position reset to: {stream.Position}");
    }
}
