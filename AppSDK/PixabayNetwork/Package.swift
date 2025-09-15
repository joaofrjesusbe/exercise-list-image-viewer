// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "PixabayNetwork",
    platforms: [
        .iOS("17.0")
    ],
    products: [
        .library(
            name: "PixabayNetwork",
            targets: ["PixabayNetwork"]
        ),
    ],
    dependencies: [
        .package(path: "../AppCore"),
    ],
    targets: [
        .target(
            name: "PixabayNetwork",
            dependencies: ["AppCore"],
            resources: [
                .copy("Resources/PixabayRecords")
            ],
            plugins: ["SecretsPlugin"]
        ),
        .testTarget(
            name: "PixabayNetworkTests",
            dependencies: ["PixabayNetwork"]
        ),
        .plugin(name: "SecretsPlugin", capability: .buildTool())
    ]
)
