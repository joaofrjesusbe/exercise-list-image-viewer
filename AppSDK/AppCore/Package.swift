// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AppCore",
    defaultLocalization: "en",
    platforms: [
        .iOS("17.0"),        
    ],
    products: [
        .library(
            name: "AppCore",
            targets: ["AppCore"]
        ),
    ],
    targets: [
        .target(
            name: "AppCore",
            dependencies: [],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "AppCoreTests",
            dependencies: ["AppCore"]
        ),
    ]
)
