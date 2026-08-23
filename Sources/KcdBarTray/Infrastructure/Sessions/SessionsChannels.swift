import Foundation
import KcdSignal

/** Every sessions channel currently on disk, whoever wrote it. */
package enum SessionsChannels {
    package static func onDisk(
        in folder: URL = SignalChannel.defaultFolder(),
        prefix: String = SessionsChannelMetrics.channelPrefix
    ) -> [String] {
        let files = (try? FileManager.default.contentsOfDirectory(atPath: folder.path)) ?? []

        return files
            .filter { $0.hasSuffix(".json") }
            .map { String($0.dropLast(".json".count)) }
            .filter { $0 == prefix || $0.hasPrefix(prefix + ".") }
            .sorted()
    }
}
