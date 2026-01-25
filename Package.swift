// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "CompactUUID",
    platforms: [
        .macOS(.v14),
        .iOS(.v15)
    ],
    products: [
        .library(name: "CompactUUID", targets: ["CompactUUID"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
        .package(url: "https://github.com/davidcvasquez/any-base-swift", from: "1.0.0"),
        // DocC plugin (command plugin that adds `generate-documentation`)
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.4.0")
    ],
    targets: [
        .target(
            name: "CompactUUID",
            dependencies: [
                .product(name: "AnyBase", package: "any-base-swift"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            path: "Sources/CompactUUID"
        ),
        .testTarget(
            name: "CompactUUIDTests",
            dependencies: ["CompactUUID"]
        ),
        .executableTarget(
            name: "CompactUUIDCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "CompactUUID"
            ],
            path: "Tools/CompactUUIDCLI"
        )
    ]
)
