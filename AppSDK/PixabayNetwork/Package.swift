// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "PixabayNetwork",
    platforms: [
        .iOS("17.0"),
        .macOS("14.0")
    ],
    products: [
        .library(
            name: "PixabayNetwork",
            targets: ["PixabayNetwork"]
        ),
    ],
    dependencies: [
        .package(path: "../AppCore"),
        .package(url: "https://github.com/kean/Nuke.git", from: "12.8.0")
    ],
    targets: [
        .target(
            name: "PixabayNetwork",
            dependencies: [
                "AppCore",
                "Nuke"
            ],
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
