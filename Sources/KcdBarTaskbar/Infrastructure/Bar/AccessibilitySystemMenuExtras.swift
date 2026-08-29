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

import AppKit
import ApplicationServices

/** Presses one of Control Center's own menu bar items by its stable identifier. */
@MainActor
package struct AccessibilitySystemMenuExtras: SystemMenuExtraPort {
    package init() {}

    package func press(_ identifier: String) -> Bool {
        guard let item = item(withIdentifier: identifier) else { return false }

        return AXUIElementPerformAction(item, kAXPressAction as CFString) == .success
    }

    private func extras() -> [AXUIElement] {
        guard let controlCentre = NSWorkspace.shared.runningApplications.first(where: {
            $0.bundleIdentifier == BarControlMetrics.controlCentreBundleIdentifier
        })
        else {
            return []
        }

        let application = AXUIElementCreateApplication(controlCentre.processIdentifier)
        guard let bar = copyValue(from: application, attribute: BarControlMetrics.extrasMenuBar),
              CFGetTypeID(bar) == AXUIElementGetTypeID()
        else {
            return []
        }

        let element = unsafeBitCast(bar, to: AXUIElement.self)

        return copyValue(from: element, attribute: kAXChildrenAttribute) as? [AXUIElement] ?? []
    }

    private func item(withIdentifier identifier: String) -> AXUIElement? {
        extras().first { element in
            copyValue(from: element, attribute: BarControlMetrics.identifierAttribute) as? String
                == identifier
        }
    }

    private func copyValue(from element: AXUIElement, attribute: String) -> CFTypeRef? {
        var value: CFTypeRef?
        guard AXUIElementCopyAttributeValue(element, attribute as CFString, &value) == .success
        else {
            return nil
        }

        return value
    }
}
