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
