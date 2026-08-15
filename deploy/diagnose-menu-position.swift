import ApplicationServices
import AppKit

func value(_ element: AXUIElement, _ attribute: String) -> CFTypeRef? {
    var out: CFTypeRef?
    guard AXUIElementCopyAttributeValue(element, attribute as CFString, &out) == .success else {
        return nil
    }
    return out
}

func settable(_ element: AXUIElement, _ attribute: String) -> Bool {
    var flag: DarwinBoolean = false
    guard AXUIElementIsAttributeSettable(element, attribute as CFString, &flag) == .success else {
        return false
    }
    return flag.boolValue
}

func describe(_ element: AXUIElement, indent: String) {
    let role = value(element, kAXRoleAttribute) as? String ?? "-"
    var origin = CGPoint.zero
    var size = CGSize.zero
    if let raw = value(element, kAXPositionAttribute) {
        AXValueGetValue(raw as! AXValue, .cgPoint, &origin)
    }
    if let raw = value(element, kAXSizeAttribute) {
        AXValueGetValue(raw as! AXValue, .cgSize, &size)
    }
    var attributeNames: CFArray?
    _ = AXUIElementCopyAttributeNames(element, &attributeNames)
    let names = attributeNames as? [String] ?? []
    print("\(indent)role=\(role) pos=\(origin) size=\(size)")
    print("\(indent)  positionSettable=\(settable(element, kAXPositionAttribute))")
    print("\(indent)  attributes=\(names)")
}

let wanted = CommandLine.arguments.dropFirst().first ?? "Tailscale"
guard let app = NSWorkspace.shared.runningApplications.first(where: {
    ($0.localizedName ?? "").localizedCaseInsensitiveContains(wanted)
}) else {
    print("no app matching \(wanted)")
    exit(1)
}

let application = AXUIElementCreateApplication(app.processIdentifier)
guard let extras = value(application, "AXExtrasMenuBar") else {
    print("\(app.localizedName ?? "?") has no AXExtrasMenuBar")
    exit(1)
}
let bar = extras as! AXUIElement
guard let item = (value(bar, kAXChildrenAttribute) as? [AXUIElement])?.first else {
    print("no menu bar item")
    exit(1)
}

print("== the status item itself ==")
describe(item, indent: "")

print("\n== pressing it ==")
print("press status: \(AXUIElementPerformAction(item, kAXPressAction as CFString).rawValue)")
Thread.sleep(forTimeInterval: 0.6)

let children = value(item, kAXChildrenAttribute) as? [AXUIElement] ?? []
print("\n== \(children.count) child element(s) after press ==")
for child in children {
    describe(child, indent: "  ")

    var target = CGPoint(x: 400, y: 800)
    if let position = AXValueCreate(.cgPoint, &target) {
        let status = AXUIElementSetAttributeValue(child, kAXPositionAttribute as CFString, position)
        print("  setPosition -> status=\(status.rawValue)")
        Thread.sleep(forTimeInterval: 0.3)
        var readBack = CGPoint.zero
        if let raw = value(child, kAXPositionAttribute) {
            AXValueGetValue(raw as! AXValue, .cgPoint, &readBack)
        }
        print("  readBack=\(readBack)  (moved=\(readBack != .zero && readBack == target))")
    }

    let items = value(child, kAXChildrenAttribute) as? [AXUIElement] ?? []
    print("  menu has \(items.count) items:")
    for entry in items.prefix(12) {
        let title = value(entry, kAXTitleAttribute) as? String ?? ""
        let enabled = value(entry, kAXEnabledAttribute) as? Bool ?? false
        print("    - \(title.isEmpty ? "<separator>" : title) enabled=\(enabled)")
    }
}

_ = AXUIElementPerformAction(item, "AXCancel" as CFString)
