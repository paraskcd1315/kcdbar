import ApplicationServices
import Foundation

@MainActor
package struct AccessibilityMenuExtraOwnership: MenuExtraOwnershipPort {
    package init() {}

    package func hasMenuExtra(pid: pid_t) -> Bool? {
        let application = AXUIElementCreateApplication(pid)
        AXUIElementSetMessagingTimeout(application, LastWindowQuitMetrics.menuExtraTimeout)
        var value: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(
            application, kAXExtrasMenuBarAttribute as CFString, &value)
        switch result {
        case .success:
            return bars(in: value).contains { !children(of: $0).isEmpty }
        case .noValue, .attributeUnsupported:
            return false
        default:
            return nil
        }
    }

    private func bars(in value: CFTypeRef?) -> [AXUIElement] {
        guard let value else { return [] }
        if CFGetTypeID(value) == AXUIElementGetTypeID() {
            return [value as! AXUIElement]
        }
        return value as? [AXUIElement] ?? []
    }

    private func children(of bar: AXUIElement) -> [AXUIElement] {
        var value: CFTypeRef?
        guard AXUIElementCopyAttributeValue(bar, kAXChildrenAttribute as CFString, &value) == .success
        else {
            return []
        }
        return value as? [AXUIElement] ?? []
    }
}
