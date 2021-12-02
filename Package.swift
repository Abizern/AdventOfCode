// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "AdventOfCode",
    platforms: [.macOS(.v12)],
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
                "AdventUtilities",
                "Inputs",
                "Advent21"
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
            resources: [.copy("Resources")]),
        .target(
            name: "Inputs",
            path: "Inputs/Sources",
            resources: [.copy("Resources")]),
        .testTarget(
            name: "InputsTests",
            dependencies: ["Inputs"],
            path: "Inputs/Tests"),
        .target(
            name: "Advent21",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                "AdventUtilities"
            ],
            path: "Advent21/Sources"),
        .testTarget(
            name: "Advent21Tests",
            dependencies: ["Advent21"],
            path: "Advent21/Tests")
    ]
)
