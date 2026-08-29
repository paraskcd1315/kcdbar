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

guard AXIsProcessTrusted() else {
    print("this process is not trusted for Accessibility")
    exit(1)
}

let attributes = [
    kAXIdentifierAttribute, kAXDescriptionAttribute, kAXTitleAttribute, kAXRoleAttribute,
    kAXSubroleAttribute, kAXHelpAttribute,
]

func string(_ element: AXUIElement, _ attribute: String) -> String {
    var value: CFTypeRef?
    guard AXUIElementCopyAttributeValue(element, attribute as CFString, &value) == .success else {
        return "-"
    }
    return (value as? String) ?? "\(value.map { "\($0)" } ?? "-")"
}

func children(_ element: AXUIElement, _ attribute: String) -> [AXUIElement] {
    var value: CFTypeRef?
    guard AXUIElementCopyAttributeValue(element, attribute as CFString, &value) == .success,
          let value
    else {
        return []
    }
    if CFGetTypeID(value) == AXUIElementGetTypeID() {
        return [value as! AXUIElement]
    }
    return value as? [AXUIElement] ?? []
}

func answers(_ element: AXUIElement) -> Bool {
    var value: CFTypeRef?
    return AXUIElementCopyAttributeValue(element, kAXRoleAttribute as CFString, &value) == .success
}

let windows = CGWindowListCopyWindowInfo([.optionAll, .excludeDesktopElements], kCGNullWindowID) as? [[String: Any]] ?? []
var layer0: [pid_t: Int] = [:]
for entry in windows {
    guard let pid = entry[kCGWindowOwnerPID as String] as? pid_t,
          (entry[kCGWindowLayer as String] as? Int ?? 0) == 0
    else { continue }
    layer0[pid, default: 0] += 1
}

let verbose = CommandLine.arguments.contains("--items")
for app in NSWorkspace.shared.runningApplications.sorted(by: { ($0.localizedName ?? "") < ($1.localizedName ?? "") }) {
    guard app.activationPolicy != .prohibited else { continue }
    let root = AXUIElementCreateApplication(app.processIdentifier)
    AXUIElementSetMessagingTimeout(root, 1.0)
    let answered = answers(root)
    let bars = children(root, kAXExtrasMenuBarAttribute)
    let items = bars.flatMap { children($0, kAXChildrenAttribute) }
    let policy = app.activationPolicy == .regular ? "regular" : "accessory"
    print("\(app.localizedName ?? "?") bundle=\(app.bundleIdentifier ?? "?") policy=\(policy) ax=\(answered ? "answered" : "silent") extras=\(items.count) layer0=\(layer0[app.processIdentifier] ?? 0)")
    guard verbose else { continue }
    for item in items {
        print("    " + attributes.map { "\($0)=\(string(item, $0))" }.joined(separator: " "))
    }
}
