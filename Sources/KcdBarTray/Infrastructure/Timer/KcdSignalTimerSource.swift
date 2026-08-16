import Foundation
import KcdSignal

/** Reads the timer channel, handing every change to the main actor. */
@MainActor
package final class KcdSignalTimerSource: TimerSignalPort {
    private let reader: SignalReader<TimerSignalPayload>
    private let projectId: Int

    package init(projectId: Int = TimerChannelMetrics.projectId) {
        self.projectId = projectId
        self.reader = SignalReader(channel: SignalChannel(TimerChannelMetrics.channelName))
    }

    package func listen(
        _ onChange: @escaping @MainActor @Sendable (TimerReading) -> Void,
        onProblem: @escaping @MainActor @Sendable (ChannelProblem) -> Void
    ) {
        let projectId = self.projectId

        reader.listen({ envelope in
            let reading = TimerSelection.reading(
                from: envelope.payload.runningTimers,
                projectId: projectId
            )

            Task { @MainActor in onChange(reading) }
        }, onProblem: { problem in
            guard let carried = SignalProblems.of(problem) else { return }

            Task { @MainActor in onProblem(carried) }
        })
    }

    package func stop() {
        reader.stop()
    }
}
