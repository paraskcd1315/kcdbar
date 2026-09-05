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

/** Asks cc-console, over its loopback server, to open its launcher under a rect of ours. */
package struct ConsolePopoverOpener: ConsolePopoverPort {
    private let read: @Sendable () -> ConsoleServer?

    package init(read: @escaping @Sendable () -> ConsoleServer? = { ConsoleConfigReader.server() }) {
        self.read = read
    }

    package var isAvailable: Bool { read()?.popoverUrl != nil }

    package func open(anchor: CGRect) async -> Bool {
        guard let server = read(), let url = server.popoverUrl else {
            BarLog.bar.notice("popover refused=noConsole")

            return false
        }

        var request = URLRequest(url: url, timeoutInterval: ConsoleServerMetrics.timeout)
        request.httpMethod = "POST"
        request.setValue("Bearer \(server.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(
            withJSONObject: [
                "anchor": [
                    "x": anchor.minX,
                    "y": anchor.minY,
                    "width": anchor.width,
                    "height": anchor.height,
                ],
                "edge": ConsoleServerMetrics.popoverEdge,
            ]
        )

        guard let (_, response) = try? await URLSession.shared.data(for: request),
              let http = response as? HTTPURLResponse
        else {
            BarLog.bar.notice("popover refused=unreachable")

            return false
        }

        BarLog.bar.notice("popover status=\(http.statusCode, privacy: .public)")

        return http.statusCode == 200
    }
}
