import AppKit
import SwiftUI

@MainActor
final class WorkspaceIconSource: ApplicationIconPort {
    private var byPid: [pid_t: Image] = [:]
    private var byBundle: [String: Image] = [:]
    private var appearanceObserver: NSObjectProtocol?

    init() {
        appearanceObserver = DistributedNotificationCenter.default().addObserver(
            forName: Notification.Name("AppleInterfaceThemeChangedNotification"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            MainActor.assumeIsolated { self?.forget() }
        }
    }

    func icon(forPid pid: pid_t) -> Image? {
        if let cached = byPid[pid] { return cached }
        guard let application = NSRunningApplication(processIdentifier: pid),
              let icon = application.icon
        else {
            return nil
        }
        let image = Image(nsImage: icon)
        byPid[pid] = image

        return image
    }

    func icon(forBundleIdentifier bundleIdentifier: String) -> Image? {
        if let cached = byBundle[bundleIdentifier] { return cached }
        guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleIdentifier)
        else {
            return nil
        }
        let image = Image(nsImage: NSWorkspace.shared.icon(forFile: url.path))
        byBundle[bundleIdentifier] = image

        return image
    }

    private func forget() {
        byPid = [:]
        byBundle = [:]
    }
}
