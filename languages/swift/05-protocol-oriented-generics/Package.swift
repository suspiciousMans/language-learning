// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ProtocolGenerics",
    platforms: [
        .macOS(.v10_15),
        .linux
    ],
    targets: [
        .executableTarget(
            name: "ProtocolGenerics",
            path: "Sources/ProtocolGenerics"
        )
    ]
)
