// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CourierService",
    dependencies: [
        .package(url: "https://github.com/jakeheis/SwiftCLI", exact: "6.0.3"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "CourierService",
            dependencies: [
                .product(name: "SwiftCLI", package: "SwiftCLI"),
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
