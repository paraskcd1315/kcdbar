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
import SystemConfiguration

/** Finds this machine's entry in the console's config, the way cc-console's own reader folds a legacy key. */
package enum ConsoleConfigReader {
    package static func server(
        hostName: String = ProcessInfo.processInfo.hostName,
        localHostName: String? = SCDynamicStoreCopyLocalHostName(nil) as String?,
        at url: URL = defaultUrl()
    ) -> ConsoleServer? {
        guard let data = try? Data(contentsOf: url),
              let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let machines = root[ConsoleServerMetrics.machinesKey] as? [String: Any]
        else {
            return nil
        }

        for name in names(of: hostName) {
            if let server = serverEntry(in: machines, key: name) {
                return server
            }
        }

        let target = targetShortForm(hostName: hostName, localHostName: localHostName)

        for key in machines.keys.sorted() where folds(key, into: target) {
            if let server = serverEntry(in: machines, key: key) {
                return server
            }
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

    private static func serverEntry(in machines: [String: Any], key: String) -> ConsoleServer? {
        guard let machine = machines[key] as? [String: Any],
              let server = machine[ConsoleServerMetrics.serverKey] as? [String: Any],
              let port = server[ConsoleServerMetrics.portKey] as? Int,
              let token = server[ConsoleServerMetrics.tokenKey] as? String,
              port > 0
        else {
            return nil
        }

        return ConsoleServer(port: port, token: token)
    }

    private static func targetShortForm(hostName: String, localHostName: String?) -> String {
        if let localHostName, !localHostName.isEmpty {
            return shortForm(localHostName)
        }

        return shortForm(hostName)
    }

    private static func folds(_ candidate: String, into target: String) -> Bool {
        let candidateShort = shortForm(candidate)

        if candidateShort == target { return true }

        let prefix = target + "-"

        guard candidateShort.hasPrefix(prefix) else { return false }

        let suffix = candidateShort.dropFirst(prefix.count)

        return !suffix.isEmpty && suffix.allSatisfy(\.isNumber)
    }

    private static func shortForm(_ name: String) -> String {
        let cut = name.firstIndex(of: ".").map { String(name[name.startIndex..<$0]) } ?? name

        return cut.lowercased()
    }
}

extension Array where Element == String {
    fileprivate func reduced() -> [String] {
        var seen: Set<String> = []

        return filter { seen.insert($0).inserted }
    }
}
