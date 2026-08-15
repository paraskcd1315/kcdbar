// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "KcdBar",
    defaultLocalization: "en",
    platforms: [.macOS(.v26)],
    products: [
        .library(name: "KcdBarDesignSystem", targets: ["KcdBarDesignSystem"]),
        .library(name: "KcdBarPreferences", targets: ["KcdBarPreferences"]),
        .library(name: "KcdBarTray", targets: ["KcdBarTray"]),
        .library(name: "KcdBarTaskbar", targets: ["KcdBarTaskbar"]),
        .library(name: "KcdBarMain", targets: ["KcdBarMain"]),
    ],
    dependencies: [
        .package(path: "../kcdsignal")
    ],
    targets: [
        .target(
            name: "KcdBarDesignSystem",
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .target(
            name: "KcdBarTray",
            dependencies: [
                "KcdBarDesignSystem",
                .product(name: "KcdSignal", package: "KcdSignal"),
            ],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .target(
            name: "KcdBarTaskbar",
            dependencies: ["KcdBarDesignSystem", "KcdBarTray"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .target(
            name: "KcdBarPreferences",
            dependencies: ["KcdBarTaskbar"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .target(
            name: "KcdBarMain",
            dependencies: [
                "KcdBarDesignSystem", "KcdBarPreferences", "KcdBarTray", "KcdBarTaskbar",
            ],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .testTarget(
            name: "KcdBarTaskbarTests",
            dependencies: ["KcdBarTaskbar"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .testTarget(
            name: "KcdBarTrayTests",
            dependencies: ["KcdBarTray"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .testTarget(
            name: "KcdBarDesignSystemTests",
            dependencies: ["KcdBarDesignSystem"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
    ]
)
