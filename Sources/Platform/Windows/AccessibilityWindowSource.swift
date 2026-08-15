import ApplicationServices
import CoreGraphics
import Foundation

struct AccessibilityWindowSource: AxWindowSourcePort {
    private static let attributeNames = [
        kAXTitleAttribute,
        kAXRoleAttribute,
        kAXSubroleAttribute,
        kAXPositionAttribute,
        kAXSizeAttribute,
        kAXMinimizedAttribute,
        WindowMatchingMetrics.fullScreenAttribute
    ]

    func windows(forPids pids: [pid_t]) -> [AxWindowRecord] {
        pids.flatMap(windows(forPid:))
    }

    private func windows(forPid pid: pid_t) -> [AxWindowRecord] {
        let application = AXUIElementCreateApplication(pid)
        AXUIElementSetMessagingTimeout(application, WindowMatchingMetrics.accessibilityTimeout)

        guard let elements = copyValue(from: application, attribute: kAXWindowsAttribute) as? [AXUIElement] else {
            return []
        }
        return elements.enumerated().compactMap { index, element in
            record(of: element, pid: pid, index: index)
        }
    }

    private func record(of element: AXUIElement, pid: pid_t, index: Int) -> AxWindowRecord? {
        var raw: CFArray?
        guard AXUIElementCopyMultipleAttributeValues(
            element,
            Self.attributeNames as CFArray,
            AXCopyMultipleAttributeOptions(),
            &raw
        ) == .success, let values = raw as? [Any] else {
            return nil
        }

        return AxWindowRecord(
            ownerPid: pid,
            cgWindowId: AxWindowIdBridge.windowId(of: element),
            title: values[safe: 0] as? String,
            role: values[safe: 1] as? String,
            subrole: values[safe: 2] as? String,
            bounds: bounds(position: values[safe: 3], size: values[safe: 4]),
            isMinimized: values[safe: 5] as? Bool ?? false,
            isFullScreen: values[safe: 6] as? Bool ?? false,
            indexInApplication: index
        )
    }

    private func bounds(position: Any?, size: Any?) -> CGRect? {
        guard let position, let size,
              CFGetTypeID(position as CFTypeRef) == AXValueGetTypeID(),
              CFGetTypeID(size as CFTypeRef) == AXValueGetTypeID()
        else {
            return nil
        }
        var origin = CGPoint.zero
        var extent = CGSize.zero
        guard AXValueGetValue(position as! AXValue, .cgPoint, &origin),
              AXValueGetValue(size as! AXValue, .cgSize, &extent)
        else {
            return nil
        }

        return CGRect(origin: origin, size: extent)
    }

    private func copyValue(from element: AXUIElement, attribute: String) -> CFTypeRef? {
        var value: CFTypeRef?
        guard AXUIElementCopyAttributeValue(element, attribute as CFString, &value) == .success else {
            return nil
        }
        return value
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
