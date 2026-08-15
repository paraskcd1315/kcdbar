import ApplicationServices
import Foundation

struct AccessibilityAuthorization: AccessibilityAuthorizationPort {
    var isTrusted: Bool {
        AXIsProcessTrusted()
    }

    func requestTrust() {
        let options = ["AXTrustedCheckOptionPrompt": true] as CFDictionary
        _ = AXIsProcessTrustedWithOptions(options)
    }
}
