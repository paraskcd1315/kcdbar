import Foundation

/** One timer as the channel writes it. */
package struct TimerSignalEntry: Codable, Sendable, Equatable {
    package let isRunning: Bool
    package let source: String
    package let jiraKey: String?
    package let detail: String
    package let startedAt: Date
    package let seconds: Int
    package let isBillable: Bool
    package let projectId: Int?
    package let contextPath: String?

    package func toEntity() -> RunningTimer {
        RunningTimer(
            projectId: projectId,
            contextPath: contextPath,
            jiraKey: jiraKey,
            detail: detail,
            startedAt: startedAt,
            isBillable: isBillable,
            source: source
        )
    }
}
