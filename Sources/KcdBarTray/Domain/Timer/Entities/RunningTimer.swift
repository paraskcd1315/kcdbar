import Foundation

/** A timer another app on this machine reports as running. */
package struct RunningTimer: Equatable, Sendable {
    package let projectId: Int?
    package let jiraKey: String?
    package let detail: String
    package let startedAt: Date
    package let isBillable: Bool
    package let source: String

    package init(
        projectId: Int?,
        jiraKey: String?,
        detail: String,
        startedAt: Date,
        isBillable: Bool,
        source: String
    ) {
        self.projectId = projectId
        self.jiraKey = jiraKey
        self.detail = detail
        self.startedAt = startedAt
        self.isBillable = isBillable
        self.source = source
    }
}
