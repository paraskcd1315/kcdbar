package protocol LoginItemPort: Sendable {
    var isEnabled: Bool { get }
    func setEnabled(_ enabled: Bool)
}
