import AppKit

@MainActor
struct WorkspaceApplicationLauncher: ApplicationLaunchPort {
    func launch(bundleIdentifier: String) {
        if let running = NSRunningApplication
            .runningApplications(withBundleIdentifier: bundleIdentifier)
            .first {
            running.activate()
            return
        }
        guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleIdentifier)
        else {
            return
        }
        NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration())
    }
}
