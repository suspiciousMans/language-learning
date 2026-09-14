// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ToolingCheck",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .linux
    ],
    targets: [
        .executableTarget(
            name: "ToolingCheck",
            path: "Sources/ToolingCheck"
        )
    ]
)
