// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "tl2swift",
    products: [
        .executable(
            name: "tl2swift",
            targets: ["tl2swift"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/PathKit.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "tl_parser_lib",
            dependencies: ["PathKit"]),
        .target(
            name: "tl2swift",
            dependencies: ["tl_parser_lib"]),
        .testTarget(
            name: "tl2swiftTests",
            dependencies: ["tl2swift"]),
    ]
)
