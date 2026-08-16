import Foundation

/** Where this machine's cc-console listens, and what it needs to be told. */
package struct ConsoleServer: Equatable, Sendable {
    package let port: Int
    package let token: String

    package init(port: Int, token: String) {
        self.port = port
        self.token = token
    }

    package var ticketUrl: URL? {
        URL(string: "http://\(ConsoleServerMetrics.host):\(port)\(ConsoleServerMetrics.ticketPath)")
    }
}
