@testable import KcdBarTaskbar

struct StubAuthorization: AccessibilityAuthorizationPort {
    var isTrusted: Bool { true }

    func requestTrust() {}
}
