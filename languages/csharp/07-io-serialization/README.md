# Project 07: File I/O, Serialization, and Data Streams — C#

**Difficulty:** intermediate  
**Prerequisites:** Project 05 (Exceptions and Nullable Reference Types), Project 04 (LINQ and Async/Await)

## Goals

- Read and write files using `FileStream`, `StreamReader`, `StreamWriter`, `BinaryReader`, and `BinaryWriter`
- Use `MemoryStream` for in-memory buffering without touching disk
- Understand `Stream.CopyTo`, `Position`, `Seek`, and `SeekOrigin` for stream manipulation
- Serialize objects to JSON using `System.Text.Json` with options for naming, null handling, and formatting
- Serialize objects to XML using `XmlSerializer` with attributes for fine-grained control
- Perform asynchronous file I/O with `ReadLineAsync`, `WriteLineAsync`, and `ReadToEndAsync`
- Enumerate directories with `EnumerateFiles`, `EnumerateDirectories`, and `EnumerateFileSystemEntries`
- Use `FileInfo` and `DirectoryInfo` for metadata access and `Path` for safe cross-platform path manipulation

## Concepts

- **`FileStream`** — low-level file access; specify `FileMode`, `FileAccess`, `FileShare`; supports `Read`, `Write`, `Seek`, `Position`, `Length`
- **`StreamReader` / `StreamWriter`** — text-oriented wrappers over streams; handle encoding (default UTF-8); offer `ReadLine`, `ReadToEnd`, `Write`, `WriteLine`
- **`BinaryReader` / `BinaryWriter`** — primitive data serialization to/from a stream; `BinaryWriter` writes length-prefixed strings; data layout must match on read/write
- **`MemoryStream`** — in-memory stream backed by a byte array; useful for buffering, testing, and intermediate processing; `ToArray` returns a copy of the buffer
- **`Stream.CopyTo`** — copies all bytes from source to destination stream; simple and efficient
- **`Position` and `Seek`** — random access within a stream; `SeekOrigin.Begin`, `SeekOrigin.Current`, `SeekOrigin.End`; `Position` is a fam...[truncated]