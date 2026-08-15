import Foundation
import KcdSignal

/** Reads this tracker's totals channel, handing every change to the main actor. */
@MainActor
package final class KcdSignalTotalsSource: TotalsSignalPort {
    private let reader: SignalReader<TotalsSignal>

    package init(channelName: String = TotalsChannelMetrics.channelName) {
        self.reader = SignalReader(channel: SignalChannel(channelName))
    }

    package func listen(
        _ onChange: @escaping @MainActor @Sendable (TrackerTotals) -> Void,
        onProblem: @escaping @MainActor @Sendable (ChannelProblem) -> Void
    ) {
        reader.listen({ envelope in
            let totals = envelope.payload.toEntity()

            Task { @MainActor in onChange(totals) }
        }, onProblem: { problem in
            guard let carried = SignalProblems.of(problem) else { return }

            Task { @MainActor in onProblem(carried) }
        })
    }

    package func stop() {
        reader.stop()
    }
}
