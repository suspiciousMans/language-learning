// Exercise 3: Advanced File I/O, Async Streams, and Directory Operations
// Covers: async file I/O (StreamReader/StreamWriter async methods),
//         Directory enumeration (EnumerateFiles, EnumerateDirectories, EnumerateFileSystemEntries),
//         file watchers, path manipulation, reading/writing with buffering

using System;
using System.IO;
using System.Threading.Tasks;

class Program
{
    static async Task Main()
    {
        var workDir = Path.Combine(Path.GetTempPath(), "csharp-07-advanced-io");
        Directory.CreateDirectory(workDir);

        Console.WriteLine($"Working directory: {workDir}\n");

        // --- Part 1: Async file I/O ---
        var asyncFile = Path.Combine(workDir, "async-example.txt");
        await WriteFileAsync(asyncFile);
        await ReadFileAsync(asyncFile);

        // --- Part 2: Directory enumeration ---
        Console.WriteLine("\n=== Directory enumeration ===");
        var subDir1 = Path.Combine(workDir, "subdir1");
        var subDir2 = Path.Combine(workDir, "subdir2");
        Directory.CreateDirectory(subDir1);
        Directory.CreateDirectory(subDir2);

        // Create some test files
        File.WriteAllText(Path.Combine(workDir, "root.txt"), "root file");
        File.WriteAllText(Path.Combine(subDir1, "a.txt"), "subdir1 file a");
        File.WriteAllText(Path.Combine(subDir1, "b.txt"), "subdir1 file b");
        File.WriteAllText(Path.Combine(subDir2, "c.txt"), "subdir2 file c");

        EnumerateDirectory(workDir);

        // --- Part 3: Recursive directory traversal ---
        Console.WriteLine("\n=== Recursive enumeration (all .txt files) ===");
        var allTxtFiles = Directory.EnumerateFiles(workDir, "*.txt", SearchOption.AllDirectories);
        foreach (var file in allTxtFiles)
        {
            var info = new FileInfo(file);
            Console.WriteLine($"  {Path.GetRelativePath(workDir, file)} — {info.Length} bytes");
        }

        // --- Part 4: FileInfo and DirectoryInfo properties ---
        Console.WriteLine("\n=== FileInfo and DirectoryInfo ===");
        var fileInfo = new FileInfo(asyncFile);
        Console.WriteLine($"File: {fileInfo.Name}");
        Console.WriteLine($"Full path: {fileInfo.FullName}");
        Console.WriteLine($"Directory: {fileInfo.DirectoryName}");
        Console.WriteLine($"Size: {fileInfo.Length} bytes");
        Console.WriteLine($"Created: {fileInfo.CreationTime}");
        Console.WriteLine($"Last write: {fileInfo.LastWriteTime}");
        Console.WriteLine($"Exists: {fileInfo.Exists}");

        // --- Part 5: Path manipulation ---
        Console.WriteLine("\n=== Path manipulation ===");
        DemonstratePaths();

        // --- Part 6: File attributes and existence checks ---
        Console.WriteLine("\n=== File attributes ===");
        var attrFile = Path.Combine(workDir, "attributed.txt");
        File.WriteAllText(attrFile, "file with attributes");
        FileInfo attrInfo = new(attrFile);
        Console.WriteLine($"Attributes before: {attrInfo.Attributes}");
        attrInfo.Attributes |= FileAttributes.Archive; // Example — set archive flag
        Console.WriteLine($"Attributes after setting Archive: {attrInfo.Attributes}");

        // --- Part 7: Cleaning up ---
        Console.WriteLine("\n=== Cleaning up ===");
        try { Directory.Delete(workDir, true); } catch { }
        Console.WriteLine("Done.");
    }

    /// <summary>
    /// Writes multiple lines to a file asynchronously using StreamWriter.
    /// </summary>
    static async Task WriteFileAsync(string path)
    {
        using var writer = new StreamWriter(path, append: false);
        await writer.WriteLineAsync("Line 1: async write");
        await writer.WriteLineAsync("Line 2: async write");
        await writer.WriteLineAsync("Line 3: async write");
        Console.WriteLine($"Wrote {path} asynchronously");
    }

    /// <summary>
    /// Reads a file asynchronously line by line using StreamReader.
    /// </summary>
    static async Task ReadFileAsync(string path)
    {
        using var reader = new StreamReader(path);
        string? line;
        int lineNum = 0;
        while ((line = await reader.ReadLineAsync()) != null)
        {
            lineNum++;
            Console.WriteLine($"  [async read line {lineNum}] {line}");
        }
    }

    /// <summary>
    /// Demonstrates Directory.EnumerateFiles, EnumerateDirectories,
    /// and EnumerateFileSystemEntries.
    /// </summary>
    static void EnumerateDirectory(string path)
    {
        Console.WriteLine($"Files in {path}:");
        foreach (var file in Directory.EnumerateFiles(path))
        {
            var info = new FileInfo(file);
            Console.WriteLine($"  {Path.GetFileName(file)} — {info.Length} bytes");
        }

        Console.WriteLine($"\nSubdirectories of {path}:");
        foreach (var dir in Directory.EnumerateDirectories(path))
        {
            Console.WriteLine($"  {Path.GetFileName(dir)}");
        }

        Console.WriteLine($"\nAll filesystem entries (files + directories):");
        foreach (var entry in Directory.EnumerateFileSystemEntries(path))
        {
            var attrs = File.GetAttributes(entry);
            bool isDir = (attrs & FileAttributes.Directory) == FileAttributes.Directory;
            Console.WriteLine($"  {(isDir ? "[DIR] " : "[FILE] ")}{Path.GetFileName(entry)}");
        }
    }

    /// <summary>
    /// Demonstrates common Path static methods for safe path manipulation.
    /// </summary>
    static void DemonstratePaths()
    {
        string filename = "document.txt";
        string directory = "/home/user/documents";
        string fullPath = Path.Combine(directory, filename);
        Console.WriteLine($"Combine: {fullPath}");

        Console.WriteLine($"GetDirectoryName: {Path.GetDirectoryName(fullPath)}");
        Console.WriteLine($"GetFileName: {Path.GetFileName(fullPath)}");
        Console.WriteLine($"GetFileNameWithoutExtension: {Path.GetFileNameWithoutExtension(fullPath)}");
        Console.WriteLine($"GetExtension: {Path.GetExtension(fullPath)}");
        Console.WriteLine($"GetFullPath (relative): {Path.GetFullPath("subdir/../other/file.txt")}");
        Console.WriteLine($"Path.GetInvalidFileNameChars exists: {Path.GetInvalidFileNameChars().Length > 0}");
        Console.WriteLine($"Path.GetInvalidPathChars exists: {Path.GetInvalidPathChars().Length > 0}");

        // Path.GetRandomFileName — useful for temp file names
        Console.WriteLine($"Random file name: {Path.GetRandomFileName()}");
        Console.WriteLine($"Temp path: {Path.GetTempPath()}");
        Console.WriteLine($"Current directory: {Directory.GetCurrentDirectory()}");
    }
}
