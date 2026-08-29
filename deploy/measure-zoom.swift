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

guard let screen = NSScreen.screens.first(where: { $0.localizedName.contains("MSI") }) ?? NSScreen.main else {
    exit(1)
}

let window = NSWindow(
    contentRect: NSRect(x: screen.frame.minX + 200, y: screen.frame.minY + 200, width: 500, height: 300),
    styleMask: [.titled, .closable, .resizable, .miniaturizable],
    backing: .buffered,
    defer: false
)
window.setFrameOrigin(NSPoint(x: screen.frame.minX + 200, y: screen.frame.minY + 200))
window.orderFrontRegardless()
RunLoop.current.run(until: Date().addingTimeInterval(0.5))

print("screen        frame=\(screen.frame)")
print("screen      visible=\(screen.visibleFrame)")
print("before zoom  window=\(window.frame)")

window.zoom(nil)
RunLoop.current.run(until: Date().addingTimeInterval(0.8))

print("after  zoom  window=\(window.frame)")

let coversDockStrip = window.frame.minY <= screen.frame.minY + 1
print("zoomed window reaches the screen's bottom edge: \(coversDockStrip)")
