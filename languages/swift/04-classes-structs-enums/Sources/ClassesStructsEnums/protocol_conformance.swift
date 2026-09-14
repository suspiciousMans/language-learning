// Exercise 3: Protocol with Struct Conformance
import Foundation

// A protocol describing anything that can be serialized
protocol Serializable {
    func toJSON() -> String
}

// Struct conforming to protocol
struct Book: Serializable {
    let title: String
    let author: String
    let year: Int

    func toJSON() -> String {
        let encoded = #"{"title":"\#(title)","author":"\#(author)","year":\#(year)}"#
        return encoded
    }
}

// Another struct
struct Album: Serializable {
    let artist: String
    let title: String
    let tracks: Int

    func toJSON() -> String {
        let encoded = #"{"title":"\#(title)","artist":"\#(artist)","tracks":\#(tracks)}"#
        return encoded
    }
}

// Generic function working with any Serializable
func printJSON<T: Serializable>(item: T) {
    print(item.toJSON())
}

let dune = Book(title: "Dune", author: "Frank Herbert", year: 1965)
let thriller = Album(artist: "Michael Jackson", title: "Thriller", tracks: 9)

printJSON(item: dune)
printJSON(item: thriller)
