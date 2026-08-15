protocol AccessibilityAuthorizing: Sendable {
    var isTrusted: Bool { get }
    func requestTrust()
}
