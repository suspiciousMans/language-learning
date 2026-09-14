// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapstoneSwiftUI",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-sqlite.git", from: "4.0.0")
    ],
    targets: [
        .executableTarget(
            name: "CapstoneSwiftUI",
            path: "Sources/CapstoneSwiftUI"
        ),
        .executableTarget(
            name: "CapstoneServer",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentSQLite", package: "fluent-sqlite")
            ],
            path: "Sources/CapstoneServer"
        )
    ]
)
