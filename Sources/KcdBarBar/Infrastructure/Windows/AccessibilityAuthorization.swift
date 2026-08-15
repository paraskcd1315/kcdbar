import ApplicationServices
import Foundation

struct AccessibilityAuthorization: AccessibilityAuthorizationPort {
    var isTrusted: Bool {
        AXIsProcessTrusted()
    }

    func requestTrust() {
        let options = [SystemDefaultsKeys.accessibilityPrompt: true] as CFDictionary
        _ = AXIsProcessTrustedWithOptions(options)
    }
}
