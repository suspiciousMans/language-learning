// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ClassesStructsEnums",
    platforms: [
        .macOS(.v10_15),
        .linux
    ],
    targets: [
        .executableTarget(
            name: "ClassesStructsEnums",
            path: "Sources/ClassesStructsEnums"
        )
    ]
)
