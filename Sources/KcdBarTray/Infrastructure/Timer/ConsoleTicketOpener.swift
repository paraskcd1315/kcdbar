import Foundation

/** Asks cc-console, over its loopback server, to open one ticket's window. */
package struct ConsoleTicketOpener: TicketOpenerPort {
    private let server: ConsoleServer?

    package init(server: ConsoleServer? = ConsoleConfigReader.server()) {
        self.server = server
    }

    package var isAvailable: Bool { server?.ticketUrl != nil }

    package func open(contextPath: String, key: String) async -> Bool {
        guard let server, let url = server.ticketUrl else { return false }

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
            return false
        }

        return http.statusCode == 200
    }
}
