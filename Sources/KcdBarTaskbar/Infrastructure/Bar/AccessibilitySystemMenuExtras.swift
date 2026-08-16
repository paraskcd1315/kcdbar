import AppKit
import ApplicationServices

/** Presses one of Control Center's own menu bar items by its stable identifier. */
@MainActor
package struct AccessibilitySystemMenuExtras: SystemMenuExtraPort {
    package init() {}

    package func press(_ identifier: String) -> Bool {
        guard let item = item(withIdentifier: identifier) else { return false }

        return AXUIElementPerformAction(item, kAXPressAction as CFString) == .success
    }

    private func extras() -> [AXUIElement] {
        guard let controlCentre = NSWorkspace.shared.runningApplications.first(where: {
            $0.bundleIdentifier == BarControlMetrics.controlCentreBundleIdentifier
        })
        else {
            return []
        }

        let application = AXUIElementCreateApplication(controlCentre.processIdentifier)
        guard let bar = copyValue(from: application, attribute: BarControlMetrics.extrasMenuBar),
              CFGetTypeID(bar) == AXUIElementGetTypeID()
        else {
            return []
        }

        let element = unsafeBitCast(bar, to: AXUIElement.self)

        return copyValue(from: element, attribute: kAXChildrenAttribute) as? [AXUIElement] ?? []
    }

    private func item(withIdentifier identifier: String) -> AXUIElement? {
        extras().first { element in
            copyValue(from: element, attribute: BarControlMetrics.identifierAttribute) as? String
                == identifier
        }
    }

    private func copyValue(from element: AXUIElement, attribute: String) -> CFTypeRef? {
        var value: CFTypeRef?
        guard AXUIElementCopyAttributeValue(element, attribute as CFString, &value) == .success
        else {
            return nil
        }

        return value
    }
}
