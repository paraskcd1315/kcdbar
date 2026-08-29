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

let app = NSApplication.shared
app.setActivationPolicy(.accessory)
app.finishLaunching()
RunLoop.current.run(until: Date().addingTimeInterval(0.6))

let screens = NSScreen.screens
for (index, screen) in screens.enumerated() {
    let frame = screen.frame
    let visible = screen.visibleFrame
    let bottomInset = visible.minY - frame.minY
    let topInset = frame.maxY - visible.maxY
    let leftInset = visible.minX - frame.minX
    let rightInset = frame.maxX - visible.maxX
    let name = screen.localizedName
    print("screen \(index) \"\(name)\" scale=\(screen.backingScaleFactor)")
    print("  frame=\(Int(frame.width))x\(Int(frame.height)) at (\(Int(frame.minX)),\(Int(frame.minY)))")
    print("  visible=\(Int(visible.width))x\(Int(visible.height)) at (\(Int(visible.minX)),\(Int(visible.minY)))")
    print("  insets bottom=\(bottomInset) top=\(topInset) left=\(leftInset) right=\(rightInset)")
}
