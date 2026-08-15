import AppKit

/** Asks an application to quit. */
@MainActor
package struct WorkspaceApplicationTerminator: ApplicationTerminationPort {
    package init() {}

    package func quit(bundleIdentifier: String) -> Bool {
        let running = NSRunningApplication
            .runningApplications(withBundleIdentifier: bundleIdentifier)
        guard !running.isEmpty else { return false }

        return running.reduce(false) { stopped, application in
            application.terminate() || stopped
        }
    }
}
