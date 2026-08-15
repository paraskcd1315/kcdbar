import CoreGraphics
import Foundation

/** Another application's menu bar item, reached through Accessibility. */
struct MenuBarItem: Equatable, Sendable, Identifiable {
    let ownerPid: pid_t
    let bundleIdentifier: String?
    let applicationName: String
    let label: String?
    let frame: CGRect?
    let index: Int

    var id: String {
        "\(ownerPid):\(index)"
    }
}
