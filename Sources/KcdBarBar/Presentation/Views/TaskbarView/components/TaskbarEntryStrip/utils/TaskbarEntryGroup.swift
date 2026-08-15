import Foundation

/** One application's adjacent entries on a display, sharing an ordering slot. */
struct TaskbarEntryGroup: Identifiable, Equatable {
    let id: String
    let entries: [TaskbarEntryModel]

    var isBanded: Bool {
        entries.count > 1
    }
}
