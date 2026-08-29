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

import CoreGraphics
@testable import KcdBarTaskbar

enum WindowFixtures {
    static let defaultBounds = CGRect(x: 0, y: 0, width: 800, height: 600)

    static func cgRecord(
        windowId: CGWindowID,
        pid: pid_t,
        title: String?,
        bounds: CGRect = defaultBounds,
        layer: Int = 0,
        isOnScreen: Bool = true,
        zOrder: Int = 0
    ) -> CgWindowRecord {
        CgWindowRecord(
            windowId: windowId,
            ownerPid: pid,
            ownerName: "App\(pid)",
            title: title,
            bounds: bounds,
            layer: layer,
            isOnScreen: isOnScreen,
            zOrder: zOrder
        )
    }

    static func axRecord(
        pid: pid_t,
        cgWindowId: CGWindowID?,
        title: String?,
        role: String? = "AXWindow",
        subrole: String? = "AXStandardWindow",
        bounds: CGRect? = defaultBounds,
        isMinimized: Bool = false,
        isFullScreen: Bool = false,
        indexInApplication: Int = 0
    ) -> AxWindowRecord {
        AxWindowRecord(
            ownerPid: pid,
            cgWindowId: cgWindowId,
            title: title,
            role: role,
            subrole: subrole,
            bounds: bounds,
            isMinimized: isMinimized,
            isFullScreen: isFullScreen,
            indexInApplication: indexInApplication
        )
    }
}
