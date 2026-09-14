// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TestingXCTest",
    platforms: [
        .macOS(.v10_15),
        .linux
    ],
    targets: [
        .executableTarget(
            name: "TestingXCTest",
            path: "Sources/TestingXCTest"
        ),
        .testTarget(
            name: "TestingXCTestTests",
            dependencies: ["TestingXCTest"],
            path: "Tests/TestingXCTestTests"
        )
    ]
)
