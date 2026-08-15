import ApplicationServices
import Foundation

package struct AccessibilityAuthorization: AccessibilityAuthorizationPort {
    package init() {}

    package var isTrusted: Bool {
        AXIsProcessTrusted()
    }

    package func requestTrust() {
        let options = [SystemDefaultsKeys.accessibilityPrompt: true] as CFDictionary
        _ = AXIsProcessTrustedWithOptions(options)
    }
}
