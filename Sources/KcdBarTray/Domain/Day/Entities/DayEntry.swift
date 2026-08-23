import Foundation

/** One tracked entry of a day, whose absent `endedAt` is what marks it still running. */
package struct DayEntry: Equatable, Sendable, Identifiable {
    package let id: Int
    package let detail: String
    package let projectId: Int?
    package let jiraKey: String?
    package let contextPath: String?
    package let startedAt: Date
    package let endedAt: Date?
    package let isBillable: Bool

    package init(
        id: Int,
        detail: String,
        projectId: Int?,
        jiraKey: String?,
        contextPath: String?,
        startedAt: Date,
        endedAt: Date?,
        isBillable: Bool
    ) {
        self.id = id
        self.detail = detail
        self.projectId = projectId
        self.jiraKey = jiraKey
        self.contextPath = contextPath
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.isBillable = isBillable
    }

    package var isRunning: Bool { endedAt == nil }

    package var opensATicket: Bool { contextPath != nil && jiraKey != nil }

    package func endedAt(by moment: Date) -> Date { endedAt ?? moment }
}
