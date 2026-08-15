import CoreGraphics
import Foundation

@MainActor
package protocol NewWindowPort {
    func supportsNewWindow(pid: pid_t) -> Bool
    func openNewWindow(pid: pid_t, placingOn frame: CGRect) -> Bool
}
