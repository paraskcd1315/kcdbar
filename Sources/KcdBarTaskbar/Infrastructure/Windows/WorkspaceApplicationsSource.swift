import AppKit

package struct WorkspaceApplicationsSource: RunningApplicationsPort {
    package init() {}

    package func currentApplications() -> [RunningApplication] {
        NSWorkspace.shared.runningApplications
            .filter { $0.activationPolicy == .regular }
            .map {
                RunningApplication(
                    pid: $0.processIdentifier,
                    bundleIdentifier: $0.bundleIdentifier,
                    localizedName: $0.localizedName,
                    launchedAt: $0.launchDate
                )
            }
    }

    package var frontmostPid: pid_t? {
        NSWorkspace.shared.frontmostApplication?.processIdentifier
    }
}
