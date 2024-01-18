// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CourierService",
    dependencies: [
        .package(url: "https://github.com/jakeheis/SwiftCLI", exact: "6.0.3"),
        .package(url: "https://github.com/JanGorman/Table", exact: "1.1.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "CourierService",
            dependencies: [
                .product(name: "SwiftCLI", package: "SwiftCLI"),
                .product(name: "Table", package: "Table"),
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "CourierServiceTests",
            dependencies: ["CourierService"],
            path: "Tests"
        )
    ]
)
