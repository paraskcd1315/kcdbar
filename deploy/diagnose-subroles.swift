import ApplicationServices
import AppKit

func value(_ element: AXUIElement, _ attribute: String) -> CFTypeRef? {
    var out: CFTypeRef?
    guard AXUIElementCopyAttributeValue(element, attribute as CFString, &out) == .success else {
        return nil
    }
    return out
}

func size(_ element: AXUIElement) -> String {
    guard let raw = value(element, kAXSizeAttribute) else { return "?" }
    var box = CGSize.zero
    guard AXValueGetValue(raw as! AXValue, .cgSize, &box) else { return "?" }
    return "\(Int(box.width))x\(Int(box.height))"
}

let wanted = CommandLine.arguments.dropFirst().first ?? "Chrome"
print("watching apps matching \(wanted), 20s — open the thing you want identified")

for tick in 1...20 {
    let apps = NSWorkspace.shared.runningApplications.filter {
        ($0.localizedName ?? "").localizedCaseInsensitiveContains(wanted)
    }
    for app in apps {
        let application = AXUIElementCreateApplication(app.processIdentifier)
        guard let windows = value(application, kAXWindowsAttribute) as? [AXUIElement] else { continue }
        print("[\(tick)] \(app.localizedName ?? "?") pid=\(app.processIdentifier) windows=\(windows.count)")
        for (index, window) in windows.enumerated() {
            let role = value(window, kAXRoleAttribute) as? String ?? "-"
            let subrole = value(window, kAXSubroleAttribute) as? String ?? "-"
            let title = value(window, kAXTitleAttribute) as? String ?? "-"
            print("    \(index) role=\(role) subrole=\(subrole) size=\(size(window)) title=\(title)")
        }
    }
    Thread.sleep(forTimeInterval: 1)
}
