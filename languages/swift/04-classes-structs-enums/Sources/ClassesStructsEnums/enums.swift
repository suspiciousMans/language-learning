// Exercise 2: Enum with Associated Values
import Foundation

// Enum can carry data per case
enum Message {
    case text(String)
    case image(url: String, caption: String?)
    case reaction(emoji: String, count: Int)
}

func describe(_ msg: Message) -> String {
    switch msg {
    case .text(let content):
        return "Text: \(content)"
    case .image(let url, let caption):
        return "Image: \(url)" + (caption != nil ? " — \(caption!)" : "")
    case .reaction(let emoji, let count):
        return "\(emoji) ×\(count)"
    }
}

let messages: [Message] = [
    .text("Hello, Swift!"),
    .image(url: "https://example.com/photo.jpg", caption: "Sunset"),
    .reaction(emoji: "❤️", count: 42),
    .text("Swift is expressive"),
    .image(url: "https://example.com/code.png", caption: nil),
]

for msg in messages {
    print(describe(msg))
}
