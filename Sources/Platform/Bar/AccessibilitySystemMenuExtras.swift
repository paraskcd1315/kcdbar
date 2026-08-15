import AppKit
import ApplicationServices

/** Presses one of Control Center's own menu bar items by its stable identifier. */
@MainActor
struct AccessibilitySystemMenuExtras: SystemMenuExtraPort {
    func press(_ identifier: String) -> Bool {
        guard let item = item(withIdentifier: identifier) else { return false }

        return AXUIElementPerformAction(item, kAXPressAction as CFString) == .success
    }

    private func item(withIdentifier identifier: String) -> AXUIElement? {
        guard let controlCentre = NSWorkspace.shared.runningApplications.first(where: {
            $0.bundleIdentifier == BarControlMetrics.controlCentreBundleIdentifier
        }) else {
            return nil
        }

        let application = AXUIElementCreateApplication(controlCentre.processIdentifier)
        guard let extras = copyValue(from: application, attribute: BarControlMetrics.extrasMenuBar),
              let items = copyValue(from: extras as! AXUIElement, attribute: kAXChildrenAttribute)
                as? [AXUIElement]
        else {
            return nil
        }

        return items.first { element in
            copyValue(from: element, attribute: BarControlMetrics.identifierAttribute) as? String
                == identifier
        }
    }

    private func copyValue(from element: AXUIElement, attribute: String) -> CFTypeRef? {
        var value: CFTypeRef?
        guard AXUIElementCopyAttributeValue(element, attribute as CFString, &value) == .success else {
            return nil
        }
        return value
    }
}
