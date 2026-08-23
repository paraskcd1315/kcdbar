import Foundation

/** Asks cc-console, over its loopback server, to open one ticket's window. */
package struct ConsoleTicketOpener: TicketOpenerPort {
    private let read: @Sendable () -> ConsoleServer?

    package init(read: @escaping @Sendable () -> ConsoleServer? = { ConsoleConfigReader.server() }) {
        self.read = read
    }

    package var isAvailable: Bool { read()?.ticketUrl != nil }

    package func open(contextPath: String, key: String) async -> Bool {
        guard let server = read(), let url = server.ticketUrl else {
            BarLog.bar.notice("ticket key=\(key, privacy: .public) refused=noConsole")

            return false
        }

        var request = URLRequest(url: url, timeoutInterval: ConsoleServerMetrics.timeout)
        request.httpMethod = "POST"
        request.setValue("Bearer \(server.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(
            withJSONObject: ["contextPath": contextPath, "key": key]
        )

        guard let (_, response) = try? await URLSession.shared.data(for: request),
              let http = response as? HTTPURLResponse
        else {
            BarLog.bar.notice("ticket key=\(key, privacy: .public) refused=unreachable")

            return false
        }

        BarLog.bar.notice(
            "ticket key=\(key, privacy: .public) status=\(http.statusCode, privacy: .public)")

        return http.statusCode == 200
    }
}
