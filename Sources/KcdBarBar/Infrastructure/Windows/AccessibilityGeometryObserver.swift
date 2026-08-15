import ApplicationServices
import Foundation

@MainActor
package final class AccessibilityGeometryObserver: WindowGeometryObserverPort {
    package init() {}

    private var observers: [pid_t: AXObserver] = [:]
    private var onChange: (() -> Void)?

    private static let notifications = [
        kAXWindowResizedNotification,
        kAXWindowMovedNotification,
        kAXWindowMiniaturizedNotification,
        kAXWindowDeminiaturizedNotification,
        kAXWindowCreatedNotification,
        kAXUIElementDestroyedNotification,
        kAXFocusedWindowChangedNotification,
        kAXTitleChangedNotification
    ]

    package func observe(pids: [pid_t], onChange: @escaping () -> Void) {
        self.onChange = onChange
        let wanted = Set(pids)

        for pid in observers.keys where !wanted.contains(pid) {
            remove(pid: pid)
        }
        for pid in wanted where observers[pid] == nil {
            add(pid: pid)
        }
    }

    package func stop() {
        observers.keys.forEach(remove(pid:))
        onChange = nil
    }

    private func add(pid: pid_t) {
        var observer: AXObserver?
        let callback: AXObserverCallback = { _, _, _, context in
            guard let context else { return }
            let owner = Unmanaged<AccessibilityGeometryObserver>.fromOpaque(context).takeUnretainedValue()
            MainActor.assumeIsolated { owner.onChange?() }
        }
        guard AXObserverCreate(pid, callback, &observer) == .success, let observer else { return }

        let application = AXUIElementCreateApplication(pid)
        let context = Unmanaged.passUnretained(self).toOpaque()
        for notification in Self.notifications {
            AXObserverAddNotification(observer, application, notification as CFString, context)
        }
        CFRunLoopAddSource(
            CFRunLoopGetMain(),
            AXObserverGetRunLoopSource(observer),
            .defaultMode
        )
        observers[pid] = observer
    }

    private func remove(pid: pid_t) {
        guard let observer = observers.removeValue(forKey: pid) else { return }
        CFRunLoopRemoveSource(
            CFRunLoopGetMain(),
            AXObserverGetRunLoopSource(observer),
            .defaultMode
        )
    }
}
