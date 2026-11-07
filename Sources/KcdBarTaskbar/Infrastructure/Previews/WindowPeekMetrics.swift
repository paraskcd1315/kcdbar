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

import AppKit
import CoreMedia

package enum WindowPeekMetrics {
    package static let fadeIn: TimeInterval = 0.15
    package static let fadeOut: TimeInterval = 0.12
    package static let overlayLevel = NSWindow.Level(rawValue: NSWindow.Level.mainMenu.rawValue - 1)
    package static let desktopLayerCeiling = Int(CGWindowLevelForKey(.normalWindow))
    package static let frameInterval = CMTime(value: 1, timescale: 60)
    package static let queueDepth = 3
    package static let outlineCornerRadius: CGFloat = 12
    package static let outlineBorderWidth: CGFloat = 1
    package static let outlineBorder = CGColor(gray: 1, alpha: 0.45)
    package static let outlineFill = CGColor(gray: 1, alpha: 0.10)
}
