import Foundation
import KcdSignal

/** Reads every tracker's totals channel, following whichever one published last. */
@MainActor
package final class KcdSignalTotalsSource: TotalsSignalPort {
    private let readers: [SignalReader<TotalsSignal>]
    private var latest = LatestTotals()

    package init(channelNames: [String] = TotalsChannelMetrics.channelNames) {
        self.readers = channelNames.map { SignalReader(channel: SignalChannel($0)) }
    }

    package func listen(
        _ onChange: @escaping @MainActor @Sendable (TrackerTotals) -> Void,
        onProblem: @escaping @MainActor @Sendable (ChannelProblem) -> Void
    ) {
        for reader in readers {
            reader.listen({ [weak self] envelope in
                let totals = envelope.payload.toEntity()
                let publishedAt = envelope.publishedAt

                Task { @MainActor in
                    guard let self, self.latest.accepts(publishedAt) else { return }

                    onChange(totals)
                }
            }, onProblem: { problem in
                guard let carried = SignalProblems.of(problem) else { return }

                Task { @MainActor in onProblem(carried) }
            })
        }
    }

    package func stop() {
        for reader in readers {
            reader.stop()
        }
    }
}
