import ApplicationServices
import AppKit

func value(_ element: AXUIElement, _ attribute: String) -> CFTypeRef? {
    var out: CFTypeRef?
    guard AXUIElementCopyAttributeValue(element, attribute as CFString, &out) == .success else {
        return nil
    }
    return out
}

func actions(_ element: AXUIElement) -> [String] {
    var names: CFArray?
    guard AXUIElementCopyActionNames(element, &names) == .success else { return [] }
    return names as? [String] ?? []
}

print("pid | app | extras children | child roles / titles / actions")

for app in NSWorkspace.shared.runningApplications where app.activationPolicy != .prohibited {
    let application = AXUIElementCreateApplication(app.processIdentifier)
    guard let extras = value(application, "AXExtrasMenuBar") else { continue }

    let bar = extras as! AXUIElement
    let children = value(bar, kAXChildrenAttribute) as? [AXUIElement] ?? []
    print("\(app.processIdentifier) | \(app.localizedName ?? "?") | \(children.count)")

    for child in children {
        let role = value(child, kAXRoleAttribute) as? String ?? "-"
        let title = value(child, kAXTitleAttribute) as? String ?? ""
        let description = value(child, kAXDescriptionAttribute) as? String ?? ""
        print("    role=\(role) title=\(title) desc=\(description) actions=\(actions(child))")
    }
}
