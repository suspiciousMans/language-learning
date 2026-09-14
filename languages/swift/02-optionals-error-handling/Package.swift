// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "OptionalsAndErrorHandling",
    platforms: [
        .macOS(.v10_15),
        .linux
    ],
    targets: [
        .executableTarget(
            name: "OptionalsAndErrorHandling",
            path: "Sources/OptionalsError"
        )
    ]
)
