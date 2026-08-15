import SwiftUI

@MainActor
protocol ApplicationIconPort {
    func icon(forPid pid: pid_t) -> Image?
    func icon(forBundleIdentifier bundleIdentifier: String) -> Image?
}
