// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AppCore",
    defaultLocalization: "en",
    platforms: [
        .iOS("17.0")        
    ],
    products: [
        .library(
            name: "AppCore",
            targets: ["AppCore"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory", from: "2.5.3"),
    ],
    targets: [
        .target(
            name: "AppCore",
            dependencies: [
                .product(name: "FactoryKit", package: "Factory")
            ],
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
