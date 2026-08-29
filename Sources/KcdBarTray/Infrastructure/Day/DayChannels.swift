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
