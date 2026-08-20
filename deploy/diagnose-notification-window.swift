import AppKit
import ApplicationServices

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

guard AXIsProcessTrusted() else {
    print("not trusted for accessibility — run this from an app that is")
    exit(1)
}

guard let entries = CGWindowListCopyWindowInfo([.optionAll, .excludeDesktopElements], kCGNullWindowID)
    as? [[String: Any]]
else {
    exit(1)
}

let owners = ["notif", "Software Update", "Actualización"]

print("every owner on screen, by layer:")
var tally: [String: Int] = [:]
for entry in entries {
    let owner = entry[kCGWindowOwnerName as String] as? String ?? "?"
    let layer = entry[kCGWindowLayer as String] as? Int ?? 0
    tally["\(owner) layer=\(layer)", default: 0] += 1
}
for key in tally.keys.sorted() {
    print("  \(key) × \(tally[key] ?? 0)")
}

print("\ncandidate notification surfaces:")
for entry in entries {
    guard let owner = entry[kCGWindowOwnerName as String] as? String,
          owners.contains(where: { owner.localizedCaseInsensitiveContains($0) }),
          let pid = entry[kCGWindowOwnerPID as String] as? pid_t,
          let layer = entry[kCGWindowLayer as String] as? Int,
          let boundsDictionary = entry[kCGWindowBounds as String] as? [String: Any],
          let bounds = CGRect(dictionaryRepresentation: boundsDictionary as CFDictionary)
    else {
        continue
    }
    print("  \(owner) pid=\(pid) layer=\(layer) bounds=\(bounds)")

    let element = AXUIElementCreateApplication(pid)
    var windowsValue: CFTypeRef?
    let read = AXUIElementCopyAttributeValue(element, kAXWindowsAttribute as CFString, &windowsValue)
    guard read == .success, let windows = windowsValue as? [AXUIElement] else {
        print("    AXWindows read failed: \(read.rawValue)")
        continue
    }
    print("    AXWindows: \(windows.count)")

    for window in windows {
        var settable: DarwinBoolean = false
        let ask = AXUIElementIsAttributeSettable(window, kAXPositionAttribute as CFString, &settable)
        var positionValue: CFTypeRef?
        _ = AXUIElementCopyAttributeValue(window, kAXPositionAttribute as CFString, &positionValue)
        var point = CGPoint.zero
        if let positionValue {
            AXValueGetValue(positionValue as! AXValue, .cgPoint, &point)
        }
        print("    window position=\(point) settable=\(settable.boolValue) ask=\(ask.rawValue)")

        guard settable.boolValue else { continue }

        var moved = CGPoint(x: point.x, y: point.y + 120)
        if let value = AXValueCreate(.cgPoint, &moved) {
            let wrote = AXUIElementSetAttributeValue(window, kAXPositionAttribute as CFString, value)
            print("    write result=\(wrote.rawValue)")
        }
    }
}
print("done")
