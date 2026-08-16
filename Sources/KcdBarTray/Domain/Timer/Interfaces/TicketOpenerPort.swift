package protocol TicketOpenerPort: Sendable {
    var isAvailable: Bool { get }
    func open(contextPath: String, key: String) async -> Bool
}
