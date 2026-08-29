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

@_silgen_name("_AXUIElementGetWindow")
func _AXUIElementGetWindow(_ element: AXUIElement, _ identifier: UnsafeMutablePointer<CGWindowID>) -> AXError

guard AXIsProcessTrusted() else {
    print("this process is not trusted for Accessibility")
    exit(1)
}
let needles = Array(CommandLine.arguments.dropFirst())
guard let app = NSRunningApplication.runningApplications(withBundleIdentifier: "com.google.Chrome").first else {
    print("Chrome is not running")
    exit(1)
}

func attribute(_ element: AXUIElement, _ name: String) -> String? {
    var value: CFTypeRef?
    guard AXUIElementCopyAttributeValue(element, name as CFString, &value) == .success else { return nil }
    return value as? String
}

func children(_ element: AXUIElement) -> [AXUIElement] {
    var value: CFTypeRef?
    guard AXUIElementCopyAttributeValue(element, kAXChildrenAttribute as CFString, &value) == .success else { return [] }
    return value as? [AXUIElement] ?? []
}

let root = AXUIElementCreateApplication(app.processIdentifier)
AXUIElementSetMessagingTimeout(root, 1)
var windows: CFTypeRef?
AXUIElementCopyAttributeValue(root, kAXWindowsAttribute as CFString, &windows)
for window in (windows as? [AXUIElement] ?? []) {
    var id: CGWindowID = 0
    _ = _AXUIElementGetWindow(window, &id)
    print("window id=\(id) title=\(attribute(window, kAXTitleAttribute) ?? "-")")
    var queue: [(AXUIElement, Int)] = [(window, 0)]
    var visited = 0
    while !queue.isEmpty, visited < 400 {
        let (element, depth) = queue.removeFirst()
        visited += 1
        let role = attribute(element, kAXRoleAttribute) ?? "-"
        let fields = [
            ("title", attribute(element, kAXTitleAttribute)),
            ("description", attribute(element, kAXDescriptionAttribute)),
            ("value", attribute(element, kAXValueAttribute)),
            ("help", attribute(element, kAXHelpAttribute)),
        ]
        for (name, text) in fields {
            guard let text, needles.contains(where: { text.localizedCaseInsensitiveContains($0) }) else { continue }
            print("  depth=\(depth) role=\(role) \(name)=\(text)")
        }
        if depth < 7 {
            queue.append(contentsOf: children(element).map { ($0, depth + 1) })
        }
    }
    print("  visited=\(visited)")
}
