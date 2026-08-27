import Foundation

/** Whether an application keeps an item in the menu bar; nil when it did not answer. */
@MainActor
package protocol MenuExtraOwnershipPort {
    func hasMenuExtra(pid: pid_t) -> Bool?
}
