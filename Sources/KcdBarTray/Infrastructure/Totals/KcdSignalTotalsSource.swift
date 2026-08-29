// Copyright 2026 Paras Mohandas Khanchandani Chandani
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import KcdSignal

/** Reads every totals channel on disk, follows whichever published last, and notices new ones. */
@MainActor
package final class KcdSignalTotalsSource: TotalsSignalPort {
    private let folder: URL
    private var readers: [String: SignalReader<TotalsSignal>] = [:]
    private var latest = LatestTotals()
    private var watch: DispatchSourceFileSystemObject?

    package init(folder: URL = SignalChannel.defaultFolder()) {
        self.folder = folder
    }

    package func listen(
        _ onChange: @escaping @MainActor @Sendable (TrackerTotals) -> Void,
        onProblem: @escaping @MainActor @Sendable (ChannelProblem) -> Void
    ) {
        subscribe(onChange, onProblem)
        startWatching(onChange, onProblem)
    }

    private func subscribe(
        _ onChange: @escaping @MainActor @Sendable (TrackerTotals) -> Void,
        _ onProblem: @escaping @MainActor @Sendable (ChannelProblem) -> Void
    ) {
        for name in TotalsChannels.onDisk(in: folder) where readers[name] == nil {
            let reader = SignalReader<TotalsSignal>(channel: SignalChannel(name, folder: folder))

            readers[name] = reader

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

    private func startWatching(
        _ onChange: @escaping @MainActor @Sendable (TrackerTotals) -> Void,
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
