// Copyright 2026 Paras Mohandas Khanchandani Chandani
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import ApplicationServices
import Foundation

@MainActor
package struct AccessibilityMenuExtraOwnership: MenuExtraOwnershipPort {
    package init() {}

    package func hasMenuExtra(pid: pid_t) -> Bool? {
        let application = AXUIElementCreateApplication(pid)
        AXUIElementSetMessagingTimeout(application, LastWindowQuitMetrics.menuExtraTimeout)
        var value: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(
            application, kAXExtrasMenuBarAttribute as CFString, &value)
        switch result {
        case .success:
            return bars(in: value).contains { !children(of: $0).isEmpty }
        case .noValue, .attributeUnsupported:
            return false
        default:
            return nil
        }
    }

    private func bars(in value: CFTypeRef?) -> [AXUIElement] {
        guard let value else { return [] }
        if CFGetTypeID(value) == AXUIElementGetTypeID() {
            return [value as! AXUIElement]
        }
        return value as? [AXUIElement] ?? []
    }

    private func children(of bar: AXUIElement) -> [AXUIElement] {
        var value: CFTypeRef?
        guard AXUIElementCopyAttributeValue(bar, kAXChildrenAttribute as CFString, &value) == .success
        else {
            return []
        }
        return value as? [AXUIElement] ?? []
    }
}
