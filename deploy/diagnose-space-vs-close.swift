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

let bundle = CommandLine.arguments.dropFirst().first ?? "com.google.Chrome"
let seconds = Double(CommandLine.arguments.dropFirst(2).first ?? "90") ?? 90
guard let app = NSRunningApplication.runningApplications(withBundleIdentifier: bundle).first else {
    print("\(bundle) is not running")
    exit(1)
}
let pid = app.processIdentifier
let root = AXUIElementCreateApplication(pid)
AXUIElementSetMessagingTimeout(root, 0.2)

let clock = DateFormatter()
clock.dateFormat = "HH:mm:ss.SSS"

nonisolated(unsafe) var held: [CGWindowID: AXUIElement] = [:]
nonisolated(unsafe) var destroyed: [CGWindowID] = []
nonisolated(unsafe) var observed: Set<CGWindowID> = []

func errorName(_ error: AXError) -> String {
    switch error {
    case .success: return "ok"
    case .invalidUIElement: return "invalid"
    case .cannotComplete: return "cannotComplete"
    case .noValue: return "noValue"
    case .attributeUnsupported: return "unsupported"
    case .apiDisabled: return "apiDisabled"
    case .notImplemented: return "notImplemented"
    default: return "err\(error.rawValue)"
    }
}

func probe(_ element: AXUIElement) -> String {
    var role: CFTypeRef?
    let roleResult = AXUIElementCopyAttributeValue(element, kAXRoleAttribute as CFString, &role)
    var subrole: CFTypeRef?
    let subroleResult = AXUIElementCopyAttributeValue(element, kAXSubroleAttribute as CFString, &subrole)
    var identifier: CGWindowID = 0
    let bridge = _AXUIElementGetWindow(element, &identifier)
    let roleText = role as? String ?? "-"
    let subroleText = subrole as? String ?? "-"
    return "role=\(errorName(roleResult)):\(roleText) sub=\(errorName(subroleResult)):\(subroleText) bridge=\(errorName(bridge)):\(identifier)"
}

let observerCallback: AXObserverCallback = { _, _, _, refcon in
    guard let refcon else { return }
    destroyed.append(CGWindowID(UInt(bitPattern: refcon)))
}

var observerBox: AXObserver?
let observerResult = AXObserverCreate(pid, observerCallback, &observerBox)
if observerResult == .success, let observer = observerBox {
    CFRunLoopAddSource(CFRunLoopGetCurrent(), AXObserverGetRunLoopSource(observer), .defaultMode)
    print("destroyed-notification observer installed")
} else {
    print("destroyed-notification observer refused: \(errorName(observerResult))")
}

func watchForDestruction(_ element: AXUIElement, _ identifier: CGWindowID) {
    guard let observer = observerBox, !observed.contains(identifier) else { return }
    let refcon = UnsafeMutableRawPointer(bitPattern: UInt(identifier))
    let result = AXObserverAddNotification(observer, element, kAXUIElementDestroyedNotification as CFString, refcon)
    if result == .success {
        observed.insert(identifier)
    }
}

func axWindows() -> (text: String, listed: Set<CGWindowID>) {
    var value: CFTypeRef?
    let result = AXUIElementCopyAttributeValue(root, kAXWindowsAttribute as CFString, &value)
    guard result == .success else { return ("ax=ERR(\(errorName(result)))", []) }
    let windows = value as? [AXUIElement] ?? []
    var listed: Set<CGWindowID> = []
    let described = windows.map { window -> String in
        var identifier: CGWindowID = 0
        _ = _AXUIElementGetWindow(window, &identifier)
        var subroleValue: CFTypeRef?
        AXUIElementCopyAttributeValue(window, kAXSubroleAttribute as CFString, &subroleValue)
        let subrole = subroleValue as? String ?? "-"
        if identifier != 0 {
            listed.insert(identifier)
            held[identifier] = window
            watchForDestruction(window, identifier)
        }
        return "\(identifier):\(subrole)"
    }
    return ("ax=\(windows.count)[\(described.joined(separator: " "))]", listed)
}

func cgWindows() -> (text: String, listed: Set<CGWindowID>, onScreen: Set<CGWindowID>) {
    let all = CGWindowListCopyWindowInfo([.optionAll, .excludeDesktopElements], kCGNullWindowID) as? [[String: Any]] ?? []
    let onScreen = Set((CGWindowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID) as? [[String: Any]] ?? [])
        .compactMap { $0[kCGWindowNumber as String] as? CGWindowID })
    let mine = all.filter { ($0[kCGWindowOwnerPID as String] as? pid_t) == pid }
    var listed: Set<CGWindowID> = []
    let described = mine.map { entry -> String in
        let identifier = entry[kCGWindowNumber as String] as? CGWindowID ?? 0
        let layer = entry[kCGWindowLayer as String] as? Int ?? -1
        let bounds = entry[kCGWindowBounds as String] as? [String: Double] ?? [:]
        let width = Int(bounds["Width"] ?? 0), height = Int(bounds["Height"] ?? 0)
        listed.insert(identifier)
        return "\(identifier):L\(layer):\(width)x\(height):\(onScreen.contains(identifier) ? "on" : "off")"
    }
    return ("cg=\(mine.count)[\(described.joined(separator: " "))]", listed, onScreen)
}

print("watching \(bundle) pid=\(pid) for \(Int(seconds))s — a line per change")
print("omitted windows carry the probe of the element AX handed out earlier")
var last = ""
let deadline = Date().addingTimeInterval(seconds)
while Date() < deadline {
    RunLoop.current.run(until: Date().addingTimeInterval(0.1))
    let cg = cgWindows()
    let ax = axWindows()
    let omitted = held.keys.filter { !ax.listed.contains($0) }.sorted()
    let omittedText = omitted.map { identifier -> String in
        let presence = cg.listed.contains(identifier) ? (cg.onScreen.contains(identifier) ? "cgOn" : "cgOff") : "cgGone"
        let notified = destroyed.contains(identifier) ? "DESTROYED" : "live"
        return "\(identifier)[\(presence) \(notified) \(probe(held[identifier]!))]"
    }
    let reading = "\(cg.text) \(ax.text) omitted=\(omitted.count)[\(omittedText.joined(separator: " | "))]"
    if reading != last {
        print("\(clock.string(from: Date())) \(reading)")
        fflush(stdout)
        last = reading
    }
}
