// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CollectionsClosuresProtocols",
    platforms: [
        .macOS(.v10_15),
        .linux
    ],
    targets: [
        .executableTarget(
            name: "CollectionsClosuresProtocols",
            path: "Sources/CollectionsClosuresProtocols"
        )
    ]
)
