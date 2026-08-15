import Foundation

/** A timer another app on this machine reports as running. */
package struct RunningTimer: Equatable, Sendable {
    package let projectId: Int?
    package let contextPath: String?
    package let jiraKey: String?
    package let detail: String
    package let startedAt: Date
    package let isBillable: Bool
    package let source: String

    package var opensATicket: Bool {
        contextPath != nil && jiraKey != nil
    }

    package init(
        projectId: Int?,
        contextPath: String? = nil,
        jiraKey: String?,
        detail: String,
        startedAt: Date,
        isBillable: Bool,
        source: String
    ) {
        self.projectId = projectId
        self.contextPath = contextPath
        self.jiraKey = jiraKey
        self.detail = detail
        self.startedAt = startedAt
        self.isBillable = isBillable
        self.source = source
    }
}
