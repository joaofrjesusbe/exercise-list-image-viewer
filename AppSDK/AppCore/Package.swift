// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AppCore",
    platforms: [
        .iOS("16.0"),        
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
            dependencies: []
        ),
        .testTarget(
            name: "AppCoreTests",
            dependencies: ["AppCore"]
        ),
    ]
)
