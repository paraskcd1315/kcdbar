import ApplicationServices
import CoreGraphics
import Foundation

final class AxLiveWindowProbe: @unchecked Sendable {
    private let lock = NSLock()
    private var held: [CGWindowID: AXUIElement] = [:]

    func hold(_ element: AXUIElement, id: CGWindowID) {
        AXUIElementSetMessagingTimeout(element, WindowMatchingMetrics.accessibilityTimeout)
        lock.lock()
        defer { lock.unlock() }
        held[id] = element
    }

    func liveOmittedIds(listed: Set<CGWindowID>) -> Set<CGWindowID> {
        lock.lock()
        let candidates = held.filter { !listed.contains($0.key) }
        lock.unlock()

        var live: Set<CGWindowID> = []
        var dead: Set<CGWindowID> = []
        for (id, element) in candidates {
            if answers(element) {
                live.insert(id)
            } else {
                dead.insert(id)
            }
        }

        lock.lock()
        for id in dead {
            held.removeValue(forKey: id)
        }
        lock.unlock()

        return live
    }

    private func answers(_ element: AXUIElement) -> Bool {
        var value: CFTypeRef?
        return AXUIElementCopyAttributeValue(element, kAXRoleAttribute as CFString, &value) == .success
    }
}
