import Foundation
import KcdSignal

/** Reads every day channel on disk, follows whichever published last, and notices new ones. */
@MainActor
package final class KcdSignalDaySource: DaySignalPort {
    private let folder: URL
    private var readers: [String: SignalReader<DaySignal>] = [:]
    private var latest = LatestDay()
    private var watch: DispatchSourceFileSystemObject?

    package init(folder: URL = SignalChannel.defaultFolder()) {
        self.folder = folder
    }

    package func listen(
        _ onChange: @escaping @MainActor @Sendable (TrackerDay) -> Void,
        onProblem: @escaping @MainActor @Sendable (ChannelProblem) -> Void
    ) {
        subscribe(onChange, onProblem)
        startWatching(onChange, onProblem)
    }

    private func subscribe(
        _ onChange: @escaping @MainActor @Sendable (TrackerDay) -> Void,
        _ onProblem: @escaping @MainActor @Sendable (ChannelProblem) -> Void
    ) {
        for name in DayChannels.onDisk(in: folder) where readers[name] == nil {
            let reader = SignalReader<DaySignal>(channel: SignalChannel(name, folder: folder))

            readers[name] = reader

            reader.listen({ [weak self] envelope in
                let day = envelope.payload.toEntity()
                let publishedAt = envelope.publishedAt

                Task { @MainActor in
                    guard let self, self.latest.accepts(publishedAt) else { return }

                    onChange(day)
                }
            }, onProblem: { problem in
                guard let carried = SignalProblems.of(problem) else { return }

                Task { @MainActor in onProblem(carried) }
            })
        }
    }

    private func startWatching(
        _ onChange: @escaping @MainActor @Sendable (TrackerDay) -> Void,
        _ onProblem: @escaping @MainActor @Sendable (ChannelProblem) -> Void
    ) {
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)

        let descriptor = open(folder.path, O_EVTONLY)

        guard descriptor >= 0 else { return }

        let source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: descriptor,
            eventMask: [.write],
            queue: DispatchQueue.global(qos: .utility)
        )

        let appeared: @Sendable () -> Void = { [weak self] in
            Task { @MainActor in self?.subscribe(onChange, onProblem) }
        }

        source.setEventHandler(handler: appeared)
        source.setCancelHandler { close(descriptor) }
        source.resume()

        watch = source
    }

    package func stop() {
        watch?.cancel()
        watch = nil

        for reader in readers.values {
            reader.stop()
        }

        readers.removeAll()
    }
}
