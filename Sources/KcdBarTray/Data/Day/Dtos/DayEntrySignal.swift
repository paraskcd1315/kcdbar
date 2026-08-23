import Foundation

/** One tracked entry, as the channel writes it. */
package struct DayEntrySignal: Codable, Sendable, Equatable {
    package let id: Int
    package let detail: String
    package let projectId: Int?
    package let jiraKey: String?
    package let contextPath: String?
    package let startedAt: Date
    package let endedAt: Date?
    package let isBillable: Bool

    package func toEntity() -> DayEntry {
        DayEntry(
            id: id,
            detail: detail,
            projectId: projectId,
            jiraKey: jiraKey,
            contextPath: contextPath,
            startedAt: startedAt,
            endedAt: endedAt,
            isBillable: isBillable
        )
    }
}
