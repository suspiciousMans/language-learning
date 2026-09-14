// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Basics",
    platforms: [
        .macOS(.v10_15),
        .linux
    ],
    targets: [
        .executableTarget(
            name: "Basics",
            path: "Sources/Basics"
        )
    ]
)
