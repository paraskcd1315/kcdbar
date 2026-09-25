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
import KcdBarTray

/** Presses one of Control Center's own menu bar items by its stable identifier. */
@MainActor
package struct AccessibilitySystemMenuExtras: SystemMenuExtraPort {
    package init() {}

    package func press(_ identifier: String) -> Bool {
        let items = items()
        guard let item = items.first(where: { self.identifier(of: $0) == identifier }) else {
            let seen = items.map { self.identifier(of: $0) ?? "nil" }.joined(separator: ",")
            BarLog.bar.notice(
                "menuExtra press id=\(identifier, privacy: .public) outcome=missing extras=\(extras().count) items=\(seen, privacy: .public)"
            )
            return false
        }

        let result = AXUIElementPerformAction(item, kAXPressAction as CFString)
        BarLog.bar.notice("menuExtra press id=\(identifier, privacy: .public) outcome=\(result.rawValue)")

        return result == .success
    }

    private func items() -> [AXUIElement] {
        extras().flatMap { [$0] + children(of: $0) }
    }

    private func extras() -> [AXUIElement] {
        NSWorkspace.shared.runningApplications
            .filter { BarControlMetrics.extrasOwnerBundleIdentifiers.contains($0.bundleIdentifier ?? "") }
            .flatMap { extras(of: $0.processIdentifier) }
    }

    private func extras(of processIdentifier: pid_t) -> [AXUIElement] {
        let application = AXUIElementCreateApplication(processIdentifier)
        guard let bar = copyValue(from: application, attribute: BarControlMetrics.extrasMenuBar),
              CFGetTypeID(bar) == AXUIElementGetTypeID()
        else {
            return []
        }

        return children(of: unsafeDowncast(bar, to: AXUIElement.self))
    }

    private func children(of element: AXUIElement) -> [AXUIElement] {
        copyValue(from: element, attribute: kAXChildrenAttribute) as? [AXUIElement] ?? []
    }

    private func identifier(of element: AXUIElement) -> String? {
        copyValue(from: element, attribute: BarControlMetrics.identifierAttribute) as? String
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
