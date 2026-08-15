import Foundation

/** One application's adjacent entries on a display, sharing an ordering slot. */
package struct TaskbarEntryGroup: Identifiable, Equatable {
    package let id: String
    package let entries: [TaskbarEntryModel]

    package var isBanded: Bool {
        entries.count > 1
    }
}
