import AppKit

struct WorkspaceApplicationsSource: RunningApplicationsPort {
    func currentApplications() -> [RunningApplication] {
        NSWorkspace.shared.runningApplications
            .filter { $0.activationPolicy == .regular }
            .map {
                RunningApplication(
                    pid: $0.processIdentifier,
                    bundleIdentifier: $0.bundleIdentifier,
                    localizedName: $0.localizedName
                )
            }
    }

    var frontmostPid: pid_t? {
        NSWorkspace.shared.frontmostApplication?.processIdentifier
    }
}
