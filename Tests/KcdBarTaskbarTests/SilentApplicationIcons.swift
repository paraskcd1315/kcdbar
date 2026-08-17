import SwiftUI

@testable import KcdBarTaskbar

@MainActor
struct SilentApplicationIcons: ApplicationIconPort {
    func icon(forPid pid: pid_t) -> Image? { nil }

    func icon(forBundleIdentifier bundleIdentifier: String) -> Image? { nil }
}
