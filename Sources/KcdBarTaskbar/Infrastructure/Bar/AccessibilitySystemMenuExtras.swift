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
        let extras = extras()
        guard let item = extras.first(where: { self.identifier(of: $0) == identifier }) else {
            BarLog.bar.notice(
                "menuExtra press id=\(identifier, privacy: .public) outcome=missing count=\(extras.count)"
            )
            for (index, extra) in extras.enumerated() {
                BarLog.bar.notice(
                    "menuExtra extra=\(index) \(describe([extra], depth: 2), privacy: .public)"
                )
            }
            return false
        }

        let result = AXUIElementPerformAction(item, kAXPressAction as CFString)
        BarLog.bar.notice(
            "menuExtra press id=\(identifier, privacy: .public) outcome=\(result.rawValue) actions=\(actions(of: item).joined(separator: ","), privacy: .public)"
        )

        return result == .success
    }

    private func describe(_ extras: [AXUIElement], depth: Int = 0) -> String {
        extras.map { element in
            let attributes = attributeNames(of: element).map { name in
                "\(name)=\(String(describing: copyValue(from: element, attribute: name) ?? "nil" as CFString).replacingOccurrences(of: "\n", with: " ").prefix(50))"
            }
            let children = copyValue(from: element, attribute: kAXChildrenAttribute) as? [AXUIElement] ?? []
            let nested = depth < 2 && !children.isEmpty ? " children[\(describe(children, depth: depth + 1))]" : ""
            return "{\(attributes.joined(separator: ",")) actions=\(actions(of: element).joined(separator: ","))\(nested)}"
        }
        .joined(separator: ";")
    }

    private func attributeNames(of element: AXUIElement) -> [String] {
        var names: CFArray?
        guard AXUIElementCopyAttributeNames(element, &names) == .success else { return [] }

        return names as? [String] ?? []
    }

    private func identifier(of element: AXUIElement) -> String? {
        copyValue(from: element, attribute: BarControlMetrics.identifierAttribute) as? String
    }

    private func actions(of element: AXUIElement) -> [String] {
        var names: CFArray?
        guard AXUIElementCopyActionNames(element, &names) == .success else { return [] }

        return names as? [String] ?? []
    }

    private func owners() -> [NSRunningApplication] {
        NSWorkspace.shared.runningApplications
            .filter { BarControlMetrics.extrasOwnerBundleIdentifiers.contains($0.bundleIdentifier ?? "") }
    }

    private func extras() -> [AXUIElement] {
        owners().flatMap { extras(of: $0.processIdentifier) }
    }

    private func extras(of processIdentifier: pid_t) -> [AXUIElement] {
        let application = AXUIElementCreateApplication(processIdentifier)
        guard let bar = copyValue(from: application, attribute: BarControlMetrics.extrasMenuBar),
              CFGetTypeID(bar) == AXUIElementGetTypeID()
        else {
            return []
        }

        let element = unsafeBitCast(bar, to: AXUIElement.self)

        return copyValue(from: element, attribute: kAXChildrenAttribute) as? [AXUIElement] ?? []
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
