// Copyright 2026 Paras Mohandas Khanchandani Chandani
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
