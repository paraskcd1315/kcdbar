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

func attribute(_ element: AXUIElement, _ name: String) -> CFTypeRef? {
    var value: CFTypeRef?
    guard AXUIElementCopyAttributeValue(element, name as CFString, &value) == .success else { return nil }
    return value
}

func axWindows() -> String {
    var value: CFTypeRef?
    let result = AXUIElementCopyAttributeValue(root, kAXWindowsAttribute as CFString, &value)
    guard result == .success else { return "ax=ERR(\(result.rawValue))" }
    let windows = value as? [AXUIElement] ?? []
    let described = windows.map { window -> String in
        var id: CGWindowID = 0
        _ = _AXUIElementGetWindow(window, &id)
        let subrole = attribute(window, kAXSubroleAttribute) as? String ?? "-"
        let full = (attribute(window, "AXFullScreen") as? Bool).map { $0 ? "F" : "f" } ?? "?"
        let mini = (attribute(window, kAXMinimizedAttribute) as? Bool).map { $0 ? "M" : "m" } ?? "?"
        return "\(id):\(subrole):\(full)\(mini)"
    }
    return "ax=\(windows.count)[\(described.joined(separator: " "))]"
}

func cgWindows() -> String {
    let all = CGWindowListCopyWindowInfo([.optionAll, .excludeDesktopElements], kCGNullWindowID) as? [[String: Any]] ?? []
    let onScreen = (CGWindowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID) as? [[String: Any]] ?? [])
        .compactMap { $0[kCGWindowNumber as String] as? CGWindowID }
    let mine = all.filter { ($0[kCGWindowOwnerPID as String] as? pid_t) == pid }
    let described = mine.map { entry -> String in
        let id = entry[kCGWindowNumber as String] as? CGWindowID ?? 0
        let layer = entry[kCGWindowLayer as String] as? Int ?? -1
        let alpha = entry[kCGWindowAlpha as String] as? Double ?? -1
        let bounds = entry[kCGWindowBounds as String] as? [String: Double] ?? [:]
        let w = Int(bounds["Width"] ?? 0), h = Int(bounds["Height"] ?? 0)
        let x = Int(bounds["X"] ?? 0), y = Int(bounds["Y"] ?? 0)
        let visible = onScreen.contains(id) ? "on" : "off"
        let rank = onScreen.firstIndex(of: id).map(String.init) ?? "-"
        return "\(id):L\(layer):a\(alpha):\(w)x\(h)@\(x),\(y):\(visible)#\(rank)"
    }
    return "cg=\(mine.count)[\(described.joined(separator: " "))]"
}

print("watching \(bundle) pid=\(pid) for \(Int(seconds))s — a line per change")
var last = ""
let deadline = Date().addingTimeInterval(seconds)
while Date() < deadline {
    let reading = "\(cgWindows()) \(axWindows())"
    if reading != last {
        print("\(clock.string(from: Date())) \(reading)")
        fflush(stdout)
        last = reading
    }
    Thread.sleep(forTimeInterval: 0.1)
}
