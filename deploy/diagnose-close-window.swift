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
import ApplicationServices

let name = CommandLine.arguments.dropFirst().first ?? "Calculator"
guard AXIsProcessTrusted() else {
    print("this process is not trusted for Accessibility")
    exit(1)
}
guard let app = NSWorkspace.shared.runningApplications.first(where: {
    $0.bundleIdentifier == name || $0.localizedName == name
}) else {
    print("\(name) is not running")
    exit(1)
}
let root = AXUIElementCreateApplication(app.processIdentifier)
var windows: CFTypeRef?
guard AXUIElementCopyAttributeValue(root, kAXWindowsAttribute as CFString, &windows) == .success,
      let first = (windows as? [AXUIElement])?.first
else {
    print("\(name) has no window to close")
    exit(1)
}
var button: CFTypeRef?
guard AXUIElementCopyAttributeValue(first, kAXCloseButtonAttribute as CFString, &button) == .success,
      let close = button
else {
    print("\(name)'s window has no close button")
    exit(1)
}
let pressed = AXUIElementPerformAction(close as! AXUIElement, kAXPressAction as CFString)
print("pressed close on \(name) pid=\(app.processIdentifier): \(pressed == .success ? "ok" : "\(pressed.rawValue)")")
