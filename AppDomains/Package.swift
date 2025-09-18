// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AppDomains",
    defaultLocalization: "en",
    platforms: [
        .iOS("17.0"),
        .macOS("14.0")
    ],
    products: [
        .library(
            name: "AppImagesList",
            targets: ["AppImagesList"]
        ),
        .library(
            name: "AppMain",
            targets: ["AppMain"]
        )
    ],
    dependencies: [
        // Reference AppGroup within AppSDK via correct relative path
        .package(path: "../AppSDK/AppGroup"),
    ],
    targets: [
        .target(
            name: "AppMain",
            dependencies: [
                "AppGroup",
                "AppImagesList"
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "AppImagesList",
            dependencies: [
                "AppGroup",
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "AppImagesListTests",
            dependencies: ["AppImagesList"]
        ),
    ]
)
