import ApplicationServices
import CoreGraphics
import Foundation

package struct AccessibilityWindowSource: AxWindowSourcePort {
    private let probe = AxLiveWindowProbe()

    package init() {}

    private static let attributeNames = [
        kAXTitleAttribute,
        kAXRoleAttribute,
        kAXSubroleAttribute,
        kAXPositionAttribute,
        kAXSizeAttribute,
        kAXMinimizedAttribute,
        WindowMatchingMetrics.fullScreenAttribute
    ]

    package func windows(forPids pids: [pid_t]) -> AxWindowScan {
        var records: [AxWindowRecord] = []
        var answered: Set<pid_t> = []

        for pid in pids {
            guard let elements = windowElements(forPid: pid) else { continue }
            answered.insert(pid)
            for (index, element) in elements.enumerated() {
                guard let record = record(of: element, pid: pid, index: index) else { continue }
                records.append(record)
                if let id = record.cgWindowId, AxWindowClassification.isSwitchable(record) {
                    probe.hold(element, id: id)
                }
            }
        }

        return AxWindowScan(
            records: records,
            answeredPids: answered,
            liveOmittedIds: probe.liveOmittedIds(listed: Set(records.compactMap(\.cgWindowId)))
        )
    }

    private func windowElements(forPid pid: pid_t) -> [AXUIElement]? {
        let application = AXUIElementCreateApplication(pid)
        AXUIElementSetMessagingTimeout(application, WindowMatchingMetrics.accessibilityTimeout)
        var value: CFTypeRef?
        guard AXUIElementCopyAttributeValue(
            application,
            kAXWindowsAttribute as CFString,
            &value
        ) == .success else {
            return nil
        }

        return value as? [AXUIElement] ?? []
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

}
