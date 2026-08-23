import Foundation
import KcdSignal

/** Every day channel currently on disk, whichever tracker wrote it. */
package enum DayChannels {
    package static func onDisk(
        in folder: URL = SignalChannel.defaultFolder(),
        prefix: String = DayChannelMetrics.channelPrefix
    ) -> [String] {
        let files = (try? FileManager.default.contentsOfDirectory(atPath: folder.path)) ?? []

        return files
            .filter { $0.hasSuffix(".json") }
            .map { String($0.dropLast(".json".count)) }
            .filter { $0 == prefix || $0.hasPrefix(prefix + ".") }
            .sorted()
    }
}
