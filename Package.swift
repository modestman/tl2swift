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
            name: "TlParserLib",
            dependencies: ["PathKit"]),
        .target(
            name: "tl2swift",
            dependencies: ["TlParserLib"]),
        .testTarget(
            name: "tl2swiftTests",
            dependencies: ["tl2swift"]),
    ]
)
