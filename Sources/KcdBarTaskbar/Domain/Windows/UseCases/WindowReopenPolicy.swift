import Foundation

package enum WindowReopenPolicy {
    /** A raise or a restore the control could not perform reopens the owning application; a minimize never does. */
    package static func reopens(after action: WindowToggleAction, performed: Bool) -> Bool {
        !performed && action != .minimize
    }
}
