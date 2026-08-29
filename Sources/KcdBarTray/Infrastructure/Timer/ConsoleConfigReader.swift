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

/** Finds this machine's entry in the console's config. */
package enum ConsoleConfigReader {
    package static func server(
        hostName: String = ProcessInfo.processInfo.hostName,
        at url: URL = defaultUrl()
    ) -> ConsoleServer? {
        guard let data = try? Data(contentsOf: url),
              let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let machines = root[ConsoleServerMetrics.machinesKey] as? [String: Any]
        else {
            return nil
        }

        for name in names(of: hostName) {
            guard let machine = machines[name] as? [String: Any],
                  let server = machine[ConsoleServerMetrics.serverKey] as? [String: Any],
                  let port = server[ConsoleServerMetrics.portKey] as? Int,
                  let token = server[ConsoleServerMetrics.tokenKey] as? String,
                  port > 0
            else {
                continue
            }

            return ConsoleServer(port: port, token: token)
        }

        return nil
    }

    package static func names(of hostName: String) -> [String] {
        let lowered = hostName.lowercased()
        let bare = lowered.hasSuffix(ConsoleServerMetrics.localSuffix)
            ? String(lowered.dropLast(ConsoleServerMetrics.localSuffix.count))
            : lowered

        return [lowered, bare, bare + ConsoleServerMetrics.localSuffix].reduced()
    }

    package static func defaultUrl() -> URL {
        FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent(ConsoleServerMetrics.configPath)
    }
}

extension Array where Element == String {
    fileprivate func reduced() -> [String] {
        var seen: Set<String> = []

        return filter { seen.insert($0).inserted }
    }
}
