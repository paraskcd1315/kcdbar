import ApplicationServices
import CoreGraphics
import Foundation

struct AccessibilityWindowSource: AxWindowSourceProviding {
    func windows(forPids pids: [pid_t]) -> [AxWindowRecord] {
        pids.flatMap(windows(forPid:))
    }

    private func windows(forPid pid: pid_t) -> [AxWindowRecord] {
        let application = AXUIElementCreateApplication(pid)
        guard let elements = copyValue(from: application, attribute: kAXWindowsAttribute) as? [AXUIElement] else {
            return []
        }
        return elements.enumerated().map { index, element in
            AxWindowRecord(
                ownerPid: pid,
                cgWindowId: AxWindowIdBridge.windowId(of: element),
                title: copyValue(from: element, attribute: kAXTitleAttribute) as? String,
                bounds: bounds(of: element),
                isMinimized: copyValue(from: element, attribute: kAXMinimizedAttribute) as? Bool ?? false,
                indexInApplication: index
            )
        }
    }

    private func bounds(of element: AXUIElement) -> CGRect? {
        guard let positionValue = copyValue(from: element, attribute: kAXPositionAttribute),
              let sizeValue = copyValue(from: element, attribute: kAXSizeAttribute)
        else {
            return nil
        }
        var origin = CGPoint.zero
        var size = CGSize.zero
        guard AXValueGetValue(positionValue as! AXValue, .cgPoint, &origin),
              AXValueGetValue(sizeValue as! AXValue, .cgSize, &size)
        else {
            return nil
        }
        return CGRect(origin: origin, size: size)
    }

    private func copyValue(from element: AXUIElement, attribute: String) -> CFTypeRef? {
        var value: CFTypeRef?
        guard AXUIElementCopyAttributeValue(element, attribute as CFString, &value) == .success else {
            return nil
        }
        return value
    }
}
