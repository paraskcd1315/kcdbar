package protocol StageManagerPort: Sendable {
    var isEnabled: Bool { get }
    func setEnabled(_ enabled: Bool)
}
