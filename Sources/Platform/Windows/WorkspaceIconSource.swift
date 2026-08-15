import AppKit
import SwiftUI

@MainActor
final class WorkspaceIconSource: ApplicationIconPort {
    private var cache: [pid_t: Image] = [:]

    func icon(forPid pid: pid_t) -> Image? {
        if let cached = cache[pid] { return cached }
        guard let application = NSRunningApplication(processIdentifier: pid),
              let icon = application.icon
        else {
            return nil
        }
        let image = Image(nsImage: icon)
        cache[pid] = image
        return image
    }
}
