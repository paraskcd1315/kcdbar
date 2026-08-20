import Foundation
import KcdSignal

package struct KcdSignalAvailability: SignalAvailabilityPort {
    package init() {}

    package var isPresent: Bool {
        FileManager.default.fileExists(atPath: SignalChannel(TimerChannelMetrics.channelName).file.path)
    }
}
