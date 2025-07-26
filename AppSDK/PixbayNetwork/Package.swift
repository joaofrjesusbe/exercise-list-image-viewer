// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "PixbayNetwork",
    platforms: [
        .iOS("16.0"),        
    ],
    products: [
        .library(
            name: "PixbayNetwork",
            targets: ["PixbayNetwork"]
        ),
    ],
    dependencies: [
        .package(path: "../AppCore"),
    ],
    targets: [
        .target(
            name: "PixbayNetwork",
            dependencies: ["AppCore"]
        ),
        .testTarget(
            name: "PixbayNetworkTests",
            dependencies: ["PixbayNetwork"]
        ),
    ]
)
