// Exercise 2: Serialization — JSON (System.Text.Json) and XML (XmlSerializer)
// Covers: deserializing/ serializing objects to JSON, JSON options (camelCase,
//         null handling, pretty print), XML serialization, attributes for control

using System;
using System.IO;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Xml.Serialization;

// --- JSON models ---
public record PersonJson
(
    string FirstName,
    string LastName,
    int Age,
    string? Email,                 // nullable — demonstrates null handling
    List<string> Skills,
    AddressJson Address
);

public record AddressJson
(
    string Street,
    string City,
    string PostalCode
);

// --- XML models (require public parameterless constructor + public properties) ---
public class PersonXml
{
    public string FirstName { get; set; } = "";
    public string LastName { get; set; } = "";
    public int Age { get; set; }
    public string? Email { get; set; }

    [XmlArray("Skills")]
    [XmlArrayItem("Skill")]
    public List<string> Skills { get; set; } = new();

    [XmlElement("Address")]
    public AddressXml Address { get; set; } = new();
}

public class AddressXml
{
    [XmlElement("Street")]
    public string Street { get; set; } = "";
    [XmlElement("City")]
    public string City { get; set; } = "";
    [XmlElement("PostalCode")]
    public string PostalCode { get; set; } = "";
}

class Program
{
    private static readonly JsonSerializerOptions JsonOptions = new()
    {
        PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
        WriteIndented = true,
        DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull,
        AllowTrailingCommas = true,
        ReadCommentHandling = JsonCommentHandling.Skip
    };

    static void Main()
    {
        Console.WriteLine("=== JSON Serialization (System.Text.Json) ===\n");

        var person = new PersonJson(
            "Jane",
            "Doe",
            30,
            "jane.doe@example.com",
            new List<string> { "C#", "Python", "SQL" },
            new AddressJson("123 Main St", "Springfield", "12345")
        );

        // Serialize to JSON string
        string jsonString = JsonSerializer.Serialize(person, JsonOptions);
        Console.WriteLine("Serialized JSON:\"\n{jsonString}\n");

        // Deserialize from JSON string
        var roundTripped = JsonSerializer.Deserialize<PersonJson>(jsonString, JsonOptions);
        Console.WriteLine($"Deserialized: {roundTripped?.FirstName} {roundTripped?.LastName}, " +
            $"{roundTripped?.Age} years old, skills: {string.Join(", ", roundTripped?.Skills ?? [])}");

        // Serialize to file
        var jsonFile = Path.Combine(Path.GetTempPath(), "person.json");
        awaitFileWriting(jsonFile, () =>
        {
            string json = JsonSerializer.Serialize(person, JsonOptions);
            File.WriteAllText(jsonFile, json);
            Console.WriteLine($"Written to: {jsonFile}");
        });

        // Deserialize from file
        var fromFile = JsonSerializer.Deserialize<PersonJson>(File.ReadAllText(jsonFile), JsonOptions);
        Console.WriteLine($"From file: {fromFile?.FirstName} lives at {fromFile?.Address?.Street}, {fromFile?.Address?.City}");

        // --- JSON with null handling ---
        Console.WriteLine("\n=== JSON null handling ===");
        var personNoEmail = new PersonJson("John", "Smith", 25, null, new List<string> { "Go" }, null);
        string jsonNoEmail = JsonSerializer.Serialize(personNoEmail, JsonOptions);
        Console.WriteLine($"Person with null email and address (excluded by DefaultIgnoreCondition):\"\n{jsonNoEmail}\n");

        // --- JSON with custom naming policy ---
        Console.WriteLine("\n=== JSON camelCase vs default ===");
        var defaultOptions = new JsonSerializerOptions { WriteIndented = true };
        string jsonDefault = JsonSerializer.Serialize(person, defaultOptions);
        Console.WriteLine($"Default (PascalCase) property names:\"\n{jsonDefault}\n");

        // --- XML Serialization ---
        Console.WriteLine("=== XML Serialization (XmlSerializer) ===\n");

        var personXml = new PersonXml
        {
            FirstName = "Jane",
            LastName = "Doe",
            Age = 30,
            Email = "jane.doe@example.com",
            Skills = new List<string> { "C#", "Python", "SQL" },
            Address = new AddressXml
            {
                Street = "123 Main St",
                City = "Springfield",
                PostalCode = "12345"
            }
        };

        var xmlSerializer = new XmlSerializer(typeof(PersonXml));

        // Serialize to XML string
        using var sw = new StringWriter();
        xmlSerializer.Serialize(sw, personXml);
        string xmlString = sw.ToString();
        Console.WriteLine("Serialized XML:\"\n{xmlString}\n");

        // Deserialize from XML string
        using var sr = new StringReader(xmlString);
        var xmlRoundTripped = (PersonXml)xmlSerializer.Deserialize(sr)!;
        Console.WriteLine($"Deserialized: {xmlRoundTripped.FirstName} {xmlRoundTripped.LastName}, " +
            $"{xmlRoundTripped.Age} years old, skills: {string.Join(", ", xmlRoundTripped.Skills)}");

        // Serialize to file
        var xmlFile = Path.Combine(Path.GetTempPath(), "person.xml");
        using (var writer = new StreamWriter(xmlFile))
        {
            xmlSerializer.Serialize(writer, personXml);
        }
        Console.WriteLine($"Written to: {xmlFile}");

        // Deserialize from file
        using (var reader = new StreamReader(xmlFile))
        {
            var fromXmlFile = (PersonXml)xmlSerializer.Deserialize(reader)!;
            Console.WriteLine($"From file: {fromXmlFile.FirstName} lives at {fromXmlFile.Address.Street}");
        }

        // Clean up temp files
        try { File.Delete(jsonFile); } catch { }
        try { File.Delete(xmlFile); } catch { }
    }

    // Helper to run synchronous file operations with a callback
    static void awaitFileWriting(string path, Action action)
    {
        action();
    }
}
