// Exercise 4: Protocols
import Foundation

// Protocol definition
protocol Vehicle {
    var speed: Double { get set }
    var name: String { get }
    func accelerate(by amount: Double)
    func description() -> String
}

// Protocol with extension providing default implementation
extension Vehicle {
    func description() -> String {
        return "\(name) traveling at \(speed) mph"
    }
}

// Conforming to protocol
class Car: Vehicle {
    var speed: Double = 0
    let name: String

    init(name: String) {
        self.name = name
    }

    func accelerate(by amount: Double) {
        speed += amount
    }
}

// Protocol composition — combining multiple protocols
protocol Flyable {
    var altitude: Double { get }
    func fly(to altitude: Double)
}

class FlyingCar: Vehicle, Flyable {
    var speed: Double = 0
    var altitude: Double = 0
    let name: String

    init(name: String) {
        self.name = name
    }

    func accelerate(by amount: Double) {
        speed += amount
    }

    func fly(to newAltitude: Double) {
        altitude = newAltitude
    }

    // Override default description
    func description() -> String {
        return "\(name) at \(speed) mph, \(altitude) ft altitude"
    }
}

// Protocol as a type — polymorphism
func describe(_ vehicle: Vehicle) {
    print(vehicle.description())
}

func demonstrateProtocols() {
    let car = Car(name: "Toyota Camry")
    car.accelerate(by: 60)
    describe(car)

    let flyingCar = FlyingCar(name: "AeroCar")
    flyingCar.accelerate(by: 100)
    flyingCar.fly(to: 10000)
    describe(flyingCar)

    // Check protocol conformance
    print("FlyingCar is Vehicle: \(flyingCar is Vehicle)")
    print("FlyingCar is Flyable: \(flyingCar is Flyable)")

    // Protocol extension — adding method to all Vehicles
    extension Vehicle {
        func honk() {
            print("\(name) goes beep!")
        }
    }

    car.honk()
    flyingCar.honk()
}

demonstrateProtocols()
