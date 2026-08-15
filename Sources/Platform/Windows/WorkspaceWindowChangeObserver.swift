import AppKit

@MainActor
final class WorkspaceWindowChangeObserver: WindowChangeObserverPort {
    private var tokens: [NSObjectProtocol] = []
    private var sweep: Timer?

    func startObserving(onChange: @escaping () -> Void) {
        stopObserving()
        let center = NSWorkspace.shared.notificationCenter
        let names: [Notification.Name] = [
            NSWorkspace.didLaunchApplicationNotification,
            NSWorkspace.didTerminateApplicationNotification,
            NSWorkspace.didActivateApplicationNotification,
            NSWorkspace.didDeactivateApplicationNotification,
            NSWorkspace.didHideApplicationNotification,
            NSWorkspace.didUnhideApplicationNotification,
            NSWorkspace.activeSpaceDidChangeNotification
        ]
        tokens = names.map { name in
            center.addObserver(forName: name, object: nil, queue: .main) { _ in
                MainActor.assumeIsolated { onChange() }
            }
        }
        sweep = Timer.scheduledTimer(withTimeInterval: TaskbarMetrics.reconciliationSweepInterval, repeats: true) { _ in
            MainActor.assumeIsolated { onChange() }
        }
    }

    func stopObserving() {
        let center = NSWorkspace.shared.notificationCenter
        tokens.forEach(center.removeObserver)
        tokens = []
        sweep?.invalidate()
        sweep = nil
    }
}
