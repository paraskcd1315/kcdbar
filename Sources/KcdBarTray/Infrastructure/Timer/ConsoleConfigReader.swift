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
