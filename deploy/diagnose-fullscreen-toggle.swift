import AppKit
import ApplicationServices

let bundle = CommandLine.arguments.dropFirst().first ?? "com.apple.TextEdit"
let wanted = (CommandLine.arguments.dropFirst(2).first ?? "true") == "true"
guard AXIsProcessTrusted() else {
    print("this process is not trusted for Accessibility")
    exit(1)
}
guard let app = NSRunningApplication.runningApplications(withBundleIdentifier: bundle).first else {
    print("\(bundle) is not running")
    exit(1)
}
let root = AXUIElementCreateApplication(app.processIdentifier)
var windows: CFTypeRef?
guard AXUIElementCopyAttributeValue(root, kAXWindowsAttribute as CFString, &windows) == .success,
      let first = (windows as? [AXUIElement])?.first
else {
    print("\(bundle) has no window")
    exit(1)
}
let result = AXUIElementSetAttributeValue(first, "AXFullScreen" as CFString, wanted as CFTypeRef)
print("AXFullScreen=\(wanted) on \(bundle) pid=\(app.processIdentifier): \(result == .success ? "ok" : "\(result.rawValue)")")
