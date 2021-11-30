// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "AdventOfCode",
    products: [
        .executable(name: "aoc", targets: ["AdventOfCodeCLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "AdventOfCodeCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "AdventUtilities"
            ],
            path: "AdventOfCodeCLI/Sources"),
        .target(
            name: "AdventUtilities",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms")
            ],
            path: "AdventUtilities/Sources"
        ),
        .testTarget(
            name: "AdventUtilitiesTests",
            dependencies: ["AdventUtilities"],
            path: "AdventUtilities/Tests",
            resources: [.copy("Resources")])
    ]
)
