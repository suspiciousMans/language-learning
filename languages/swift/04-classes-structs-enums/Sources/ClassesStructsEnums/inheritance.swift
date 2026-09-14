// Exercise 4: Inheritance and Overrides
import Foundation

// Base class
class Shape {
    let color: String
    init(color: String) { self.color = color }
    func area() -> Double { return 0 }
    func describe() -> String { return "A \(color) shape" }
}

// Subclass
class Circle: Shape {
    let radius: Double
    init(radius: Double, color: String) {
        self.radius = radius
        super.init(color: color)
    }
    override func area() -> Double {
        return Double.pi * radius * radius
    }
    override func describe() -> String {
        return "A \(color) circle with radius \(radius)"
    }
}

// Another subclass
class Rectangle: Shape {
    let width: Double
    let height: Double
    init(width: Double, height: Double, color: String) {
        self.width = width
        self.height = height
        super.init(color: color)
    }
    override func area() -> Double {
        return width * height
    }
    override func describe() -> String {
        return "A \(color) rectangle with width \(width) and height \(height)"
    }
}

let shapes: [Shape] = [
    Circle(radius: 5.0, color: "red"),
    Rectangle(width: 4.0, height: 6.0, color: "blue"),
    Circle(radius: 2.5, color: "green"),
]

for shape in shapes {
    print("\(shape.describe()) → area: \(shape.area())")
}
