import AppKit
import ApplicationServices

@MainActor
package struct AccessibilityWindowControl: WindowControlPort {
    package init() {}

    package func perform(_ action: WindowToggleAction, on window: ManagedWindow) -> Bool {
        guard let element = element(for: window) else { return false }
        switch action {
        case .minimize:
            return setMinimized(true, on: element)
        case .restore:
            guard setMinimized(false, on: element) else { return false }
            return focus(element, pid: window.ownerPid)
        case .raise:
            return focus(element, pid: window.ownerPid)
        }
    }

    package func close(_ window: ManagedWindow) -> Bool {
        guard let element = element(for: window),
              let button = copyValue(from: element, attribute: kAXCloseButtonAttribute)
        else {
            return false
        }
        return AXUIElementPerformAction(button as! AXUIElement, kAXPressAction as CFString) == .success
    }

    package func setFrame(_ frame: CGRect, on window: ManagedWindow) -> Bool {
        guard let element = element(for: window) else { return false }
        let target = ScreenCoordinateConverter.toAccessibility(frame)
        var origin = target.origin
        var size = target.size
        guard let positionValue = AXValueCreate(.cgPoint, &origin),
              let sizeValue = AXValueCreate(.cgSize, &size)
        else {
            return false
        }
        let movedOk = AXUIElementSetAttributeValue(element, kAXPositionAttribute as CFString, positionValue) == .success
        let sizedOk = AXUIElementSetAttributeValue(element, kAXSizeAttribute as CFString, sizeValue) == .success
        return movedOk && sizedOk
    }

    private func focus(_ element: AXUIElement, pid: pid_t) -> Bool {
        NSRunningApplication(processIdentifier: pid)?.activate()
        let raised = AXUIElementPerformAction(element, kAXRaiseAction as CFString) == .success
        AXUIElementSetAttributeValue(element, kAXMainAttribute as CFString, kCFBooleanTrue)
        return raised
    }

    private func setMinimized(_ minimized: Bool, on element: AXUIElement) -> Bool {
        AXUIElementSetAttributeValue(
            element,
            kAXMinimizedAttribute as CFString,
            minimized ? kCFBooleanTrue : kCFBooleanFalse
        ) == .success
    }

    private func element(for window: ManagedWindow) -> AXUIElement? {
        let application = AXUIElementCreateApplication(window.ownerPid)
        guard let elements = copyValue(from: application, attribute: kAXWindowsAttribute) as? [AXUIElement] else {
            return nil
        }
        if let windowId = window.identity.cgWindowId,
           let match = elements.first(where: { AxWindowIdBridge.windowId(of: $0) == windowId }) {
            return match
        }
        if let title = window.title, !title.isEmpty,
           let match = elements.first(where: { copyValue(from: $0, attribute: kAXTitleAttribute) as? String == title }) {
            return match
        }
        return nil
    }

    private func copyValue(from element: AXUIElement, attribute: String) -> CFTypeRef? {
        var value: CFTypeRef?
        guard AXUIElementCopyAttributeValue(element, attribute as CFString, &value) == .success else {
            return nil
        }
        return value
    }
}
