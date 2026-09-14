# Project 07: I/O and Serialization — C#

**Difficulty:** intermediate to advanced  
**Prerequisites:** C# 00–04 (basics, classes/interface records, generics/delegates/events, LINQ/async-await)

## Goals

- Read and write files using `FileStream`, `StreamReader`, `StreamWriter`, and `BinaryReader`/`BinaryWriter`
- Serialize and deserialize objects to JSON using `System.Text.Json`
- Serialize and deserialize objects to XML using `System.Xml.Serialization`
- Work asynchronously with `async`/`await` for I/O-bound operations, including cancellation
- Understand the difference between binary, text, JSON, and XML serialization formats
- Learn advanced file I/O patterns: buffered I/O, file monitoring, compression, and checksums

## Concepts

### File and Stream I/O

- **`File`** — static helper class for common file operations (read all text, write all bytes, copy, move, delete, check existence, get attributes)
- **`FileStream`** — low-level stream wrapping a file, supports random access by position, synchronous and asynchronous reads/writes
- **`StreamReader` / `StreamWriter`** — text-based reading/writing with encoding support (UTF-8 default), buffered I/O; works on any `Stream`
- **`BinaryReader` / `BinaryWriter`** — binary reading/writing of primitive types (integers, floats, strings, etc.), ideal for custom binary formats
- **`FileOptions`** — flags like `Asynchronous`, `DeleteOnClose`, `RandomAccess`, `WriteThrough`, `Encrypted` to tune stream behavior
- **`FileShare`** — controls how a file can be accessed by other processes while open (Read, Write, ReadWrite, None)
- **Buffered I/O** — `StreamReader`/`StreamWriter` buffer text; wrapping a `FileStream` in a `BufferedStream` adds binary buffering
- **Seek and position** — `FileStream.Position` and `FileStream.Seek()` let you move to arbitrary offsets; random access is key for indexed or partial reads

### Serialization

- **JSON (`System.Text.Json`)** — built-in, fast, async-friendly serialization; controls via `JsonSerializerOptions` (property naming, case-insensitivity, converters, write dates as strings, ignore nulls, encoder);
  - `JsonSerializer.Serialize`/`Deserialize` for sync; `SerializeAsync`/`DeserializeAsync` for streams and async
  - `JsonSerializerOptions` customizations: `PropertyNamingPolicy`, `PropertyNameCaseInsensitive`, `DefaultIgnoreCondition`, `WriteIndented`, `Converters`, `Encoder`
  - Polymorphism via `JsonDerivedType` attribute or `JsonSerializerOptions.TypeInfoResolver` for inheritance hierarchies
  - Custom converters for types not natively supported (e.g., `DateTime` custom format, `Guid` formatting)
- **XML (`System.Xml.Serialization`)** — attribute-based serialization with `XmlSerializer`; control element/attribute names via `[XmlElement]`, `[XmlAttribute]`, `[XmlIgnore]`; serialize to file or stream; supports collections
  - Differences from JSON: XML is more verbose, attribute-based serialization is declarative, async is not built in (use sync + wrap or manual XML APIs like `XmlWriter` for async-friendly scenarios)
  - Namespaces: `[XmlRoot(Namespace = "...")]` and `XmlSerializerNamespaces` for qualified elements
  - Custom serialization: implement `IXmlSerializable` for full control over XML representation

### Advanced I/O

- **`FileSystemWatcher`** — monitor directories and files for changes (Created, Changed, Deleted, Renamed, Error); be aware of multiple events per file operation, buffering, and race conditions
- **Compression** — `GZipStream` and `BrotliStream` (via `System.IO.Compression`) compress/decompress data on-the-fly; `CompressionMode.Compress` or `Decompress`, wrap around any stream
- **Checksum/hashing** — `SHA256`, `MD5`, `SHA1`, `HMACSHA256` via `System.Security.Cryptography`; compute hash of a file with `FileStream` + crypto stream or `IncrementalHash`
- **Memory-mapped files** — `MemoryMappedFile` for shared-memory and large file access without loading entire file into managed memory; `MemoryMappedViewAccessor` for random access
- **Cancellation** — `CancellationToken` passed to async I/O methods (`StreamReader.ReadToEndAsync`, `File.WriteAllTextAsync`, etc.); observe and pass through call chains; use `CancellationTokenSource` to trigger cancellation

## Setup

### Install .NET SDK

Install .NET 8.0 or later. Verify:

```bash
dotnet --version
```

### Creating the project

The project file (`07-io-serialization.csproj`) targets .NET 8.0 and uses explicit usings disabled and nullable reference types enabled. To build and run:

```bash
dotnet build
dotnet run
```

## Exercises

### Exercise 1: File I/O with FileStream and Text Files

File: `FileStreams.cs`

Covers:
- `File` static class for simple operations
- `FileStream` for random-access reads (seeking to a position, reading blocks)
- `StreamReader` / `StreamWriter` for text I/O (encoding, line-by-line reading, writing with formatting)
- `BinaryReader` / `BinaryWriter` for binary data (writing/reading structured primitive data)
- `FileOptions.Asynchronous` and async I/O with `ReadAsync`/`WriteAsync`
- `FileShare` for concurrent access scenarios
- `FileInfo` for metadata (size, dates, attributes)

What you will do:
- Create a text file with `File.WriteAllText` / `File.WriteAllLines`
- Read back with `File.ReadAllText` / `File.ReadAllLines` / `StreamReader`
- Use `FileStream` to write a binary file with `BinaryWriter` (ints, doubles, strings)
- Use `FileStream` position/seek to read specific records out of order
- Use async file I/O to read/write large text files without blocking
- Check file existence, size, dates via `File`/`FileInfo`
- Demonstrate `FileShare.Read` so another reader can open the same file

### Exercise 2: JSON and XML Serialization

File: `Serialization.cs`

Covers:
- Define serializable models with properties (records, classes)
- JSON serialization with `System.Text.Json`:
  - Configure `JsonSerializerOptions`: camelCase naming, indented output, ignore nulls, case-insensitive deserialization
  - Serialize to string and to file (`File.WriteAllText` / `FileStream`)
  - Deserialize from string and from file, with validation
  - Polymorphic serialization with `[JsonDerivedType]` and `JsonSerializerOptions.TypeInfoResolver`
  - Custom `JsonConverter` for a `DateTime` or other type needing special formatting
  - Use async serialization (`SerializeAsync` / `DeserializeAsync`) with streams
- XML serialization with `System.Xml.Serialization`:
  - Decorate classes with `[XmlRoot]`, `[XmlElement]`, `[XmlAttribute]`, `[XmlIgnore]`
  - Serialize to file and to `StringWriter` for inspection
  - Deserialize back, handling missing elements gracefully
  - Control namespaces with `XmlSerializerNamespaces`
  - Serialize collections (array/list properties)
  - Note: XML serialization does not support async natively; wrap sync calls appropriately

What you will do:
- Create a `Person` record/class, a `Product` class, an `Order` class with nested items
- Serialize a list of people to JSON (formatted and compact)
- Deserialize JSON back, handling case differences and missing fields
- Demonstrate polymorphism: serialize a list of `Shape` objects where some are `Circle` and some `Rectangle`
- Write a custom `JsonConverter` to format `DateTime` as ISO 8601 strings
- Serialize the same data to XML with attributes and elements, including a namespace
- Compare file sizes and readability between JSON and XML

### Exercise 3: Advanced I/O — File Monitoring, Compression, Checksums

File: `AdvancedIO.cs`

Covers:
- `FileSystemWatcher` to monitor a directory for file creation, modification, and deletion
- Debounce logic to handle multiple events per file operation
- `GZipStream` to compress a file into a `.gz` archive and decompress it back
- `BrotliStream` for higher compression ratios (modern web-friendly compression)
- `SHA256` to compute file checksums (hash the entire file via `FileStream` + `CopyToToCryptoStream` or `IncrementalHash`)
- `MemoryMappedFile` for large-file random access without full loading
- `CancellationToken` integration: create a file-watching loop that stops when cancelled
- `FileOptions` and `FileShare` flags in advanced scenarios

What you will do:
- Set up a `FileSystemWatcher` on a directory; log events and debounce rapid-fire events
- Compress a large text file with GZip and verify the decompressed content matches
- Compress the same file with Brotli and compare sizes
- Compute SHA-256 hashes of original and compressed files
- Use `MemoryMappedFile` to read a specific region of a large file (e.g., a header or index)
- Demonstrate cancellation: watch files until the user presses a key or a timeout, then stop cleanly

## Expected Output

### FileStreams (console output sample)

```
=== Exercise 1: File I/O with FileStream and Text Files ===

--- Text File Operations ---
Created test.txt with 5 lines
Contents (ReadAllText):
Line 1: Hello from C#
Line 2: File I/O is fun
Line 3: Streaming data
Line 4: Async I/O too
Line 5: Goodbye
Read line by line:
  Line 1
  Line 2
  Line 3
  Line 4
  Line 5
File exists: True
File size: 128 bytes
Last write time: [timestamp]

--- Binary File with BinaryWriter/BinaryReader ---
Created data.bin with 3 records
Record 1: ID=1, Name="Alice", Score=95.5
Record 2: ID=2, Name="Bob", Score=87.3
Record 3: ID=3, Name="Charlie", Score=92.1

--- Random Access with FileStream ---
File size: 124 bytes
Record count: 3
Reading record 2 directly: ID=2, Name="Bob", Score=87.3

--- Async File I/O ---
Writing async file... done (45ms)
Reading async file... done (12ms)
Async file has 1000 lines

--- FileInfo Metadata ---
Name: test.txt
Length: 128 bytes
CreationTime: [timestamp]
LastWriteTime: [timestamp]
Extension: .txt
Directory: [path]
```

### Serialization (console output sample)

```
=== Exercise 2: JSON and XML Serialization ===

--- JSON Serialization ---
Serialized Person (default):
{"Name":"Alice","Age":30,"Email":"alice@example.com"}

Serialized Person (camelCase, indented):
{
  "name": "Alice",
  "age": 30,
  "email": "alice@example.com"
}

Serialized with ignore nulls:
{"name":"Bob","age":25}

Deserialized: Person(Name=Bob, Age=25, Email=bob@example.com)

--- JSON Async Serialization ---
Wrote 1000 records to people.json in 42ms
Read back 1000 records in 38ms

--- Polymorphic JSON ---
Serialized shapes:
[{"Type":"Circle","Radius":5.0},{"Type":"Rectangle","Width":4.0,"Height":6.0}]

Deserialized shapes:
- Circle(Radius=5.0) area=78.53981633974483
- Rectangle(Width=4.0, Height=6.0) area=24.0

--- Custom DateTime Converter ---
Event with custom date format:
  { Name = Team Meeting, Date = 2026-03-15T10:00:00 }

--- XML Serialization ---
Serialized XML:
<?xml version="1.0" encoding="utf-8"?>
<People xmlns="http://example.com/people">
  <Person name="Alice" age="30">
    <Email>alice@example.com</Email>
  </Person>
  <Person name="Bob" age="25" />
</People>

Deserialized from XML: 2 people
  Alice (30) - alice@example.com
  Bob (25) - (no email)
```

### AdvancedIO (console output sample)

```
=== Exercise 3: Advanced I/O ===

--- FileSystemWatcher ---
Watching directory: [temp path]
(Press any key to stop watching)
[14:05:23] Created: newfile.txt
[14:05:23] Changed: newfile.txt (content: Hello world)
[14:05:30] Deleted: newfile.txt
Debounced events processed: 3

--- Compression ---
Original file size: 1048576 bytes
GZip compressed: 12500 bytes (98.8% reduction)
Brotli compressed: 10200 bytes (99.0% reduction)
Decompressed matches original: True

--- SHA-256 Checksums ---
Original file SHA-256: a1b2c3d4e5f6...
GZip file SHA-256: f6e5d4c3b2a1...
Brotli file SHA-256: e5f6a1b2c3d4...

--- Memory-Mapped File ---
Mapped 10MB file
First 100 bytes: Hello, this is a large file...
Read 1000 bytes from offset 5000000: [data from middle of file]
File size: 10485760 bytes

--- Cancellation ---
Watching for 3 seconds...
Cancelled after 3000ms. Events captured: 5
```

## Completion Checklist

- [ ] You can read and write text files with `File` static methods and `StreamReader`/`StreamWriter`
- [ ] You can use `FileStream` for random-access reads and writes (Position, Seek)
- [ ] You can write and read binary data with `BinaryWriter`/`BinaryReader`
- [ ] You can perform async file I/O with `ReadAsync`/`WriteAsync` or `File.ReadAllTextAsync` etc.
- [ ] You understand `FileShare` and can open a file for reading while another process writes
- [ ] You can serialize objects to JSON with `System.Text.Json`, controlling naming, indentation, and null handling
- [ ] You can deserialize JSON back to objects, handling missing fields and case-insensitive properties
- [ ] You can serialize polymorphic object graphs to JSON using `[JsonDerivedType]`
- [ ] You can write a custom `JsonConverter` for types that need special formatting
- [ ] You can serialize/deserialize objects to XML with `XmlSerializer` and attributes
- [ ] You understand the differences between JSON and XML serialization (performance, verbosity, async support)
- [ ] You can set up a `FileSystemWatcher` and handle events with debouncing
- [ ] You can compress files with GZip and Brotli and verify decompression
- [ ] You can compute SHA-256 checksums of files
- [ ] You can use `MemoryMappedFile` for large-file access
- [ ] You can integrate `CancellationToken` with async I/O and file monitoring

## Hints

- Prefer `async` I/O for files — it scales better under load and doesn't block threads; use `FileOptions.Asynchronous` on `FileStream` for full async support
- Always specify encoding explicitly (`Encoding.UTF8`) when using `StreamReader`/`StreamWriter` unless you're sure about the default
- `BinaryWriter` writes a length-prefixed string by default — be aware when interoperating with non-.NET readers
- `System.Text.Json` is faster and more allocation-friendly than `Newtonsoft.Json` for most scenarios; it's the recommended choice in .NET 8
- For XML, `[XmlIgnore]` on a property excludes it from serialization; `[XmlElement]` and `[XmlAttribute]` control element vs attribute
- `FileSystemWatcher` fires multiple events for a single file operation (e.g., Created + Changed) — debounce by delaying or coalescing
- When computing file hashes, use `SHA256.HashData(File.ReadAllBytes(...))` for small files, or stream with `IncrementalHash` or `CryptoStream` for large files to avoid loading everything into memory
- `MemoryMappedFile` is useful when you need random access to a large file without loading it all into managed memory; be sure to dispose the accessor
- Cancellation is cooperative — always check `token.ThrowIfCancellationRequested()` or pass the token to async APIs that accept it

## Reference

- [System.IO namespace](https://learn.microsoft.com/dotnet/api/system.io)
- [System.Text.Json](https://learn.microsoft.com/dotnet/standard/serialization/system-text-json-overview)
- [XmlSerializer](https://learn.microsoft.com/dotnet/api/system.xml.serialization.xmlserializer)
- [FileSystemWatcher](https://learn.microsoft.com/dotnet/api/system.io.filesystemwatcher)
- [MemoryMappedFile](https://learn.microsoft.com/dotnet/api/system.io.memorymappedfiles.memorymappedfile)
- [GZipStream](https://learn.microsoft.com/dotnet/api/system.io.compression.gzipstream)
- [BrotliStream](https://learn.microsoft.com/dotnet/api/system.io.compression.brotlistream)
- [SHA256](https://learn.microsoft.com/dotnet/api/system.security.cryptography.sha256)

## Style Reference

This README follows the same structure as projects 05 (Exceptions & Nullable Reference Types) and 06 (Collections & LINQ Deep Dive): Goals, Concepts, Setup, Exercises with file references, Expected Output sample, Completion Checklist, and Hints.

---

*Parallel project: C# 08 covers Reflection and Attributes — building on serialization concepts here.*
