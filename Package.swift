// swift-tools-version: 5.8

import PackageDescription;

let package = Package(
    name: "SwiftUIWindowReader",
    platforms: [.macOS(.v13)],
    products: [
        .library(
            name: "WindowReader",
            targets: ["WindowReader"]),
    ],
    targets: [
        .target(
            name: "WindowReader",
            dependencies: []),
    ]
);
