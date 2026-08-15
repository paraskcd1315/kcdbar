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
        .library(name: "KcdBarBar", targets: ["KcdBarBar"]),
        .library(name: "KcdBarMain", targets: ["KcdBarMain"]),
    ],
    targets: [
        .target(
            name: "KcdBarDesignSystem",
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .target(
            name: "KcdBarTray",
            dependencies: ["KcdBarDesignSystem"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .target(
            name: "KcdBarBar",
            dependencies: ["KcdBarDesignSystem", "KcdBarTray"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .target(
            name: "KcdBarPreferences",
            dependencies: ["KcdBarBar"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .target(
            name: "KcdBarMain",
            dependencies: [
                "KcdBarDesignSystem", "KcdBarPreferences", "KcdBarTray", "KcdBarBar",
            ],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .testTarget(
            name: "KcdBarBarTests",
            dependencies: ["KcdBarBar"],
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
