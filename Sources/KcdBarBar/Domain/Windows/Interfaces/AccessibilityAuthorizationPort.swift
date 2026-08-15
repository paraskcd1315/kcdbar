package protocol AccessibilityAuthorizationPort: Sendable {
    var isTrusted: Bool { get }
    func requestTrust()
}
