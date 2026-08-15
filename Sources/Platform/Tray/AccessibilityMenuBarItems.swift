import AppKit
import ApplicationServices

@MainActor
struct AccessibilityMenuBarItems: MenuBarItemsPort {
    func items() -> [MenuBarItem] {
        NSWorkspace.shared.runningApplications.flatMap(items(of:))
    }

    func press(_ item: MenuBarItem) -> Bool {
        guard let element = element(for: item) else { return false }

        return AXUIElementPerformAction(element, kAXPressAction as CFString) == .success
    }

    func menu(for item: MenuBarItem) -> [MenuBarEntry] {
        guard let element = element(for: item) else { return [] }

        let rows = rows(of: element) ?? openedRows(of: element)

        return rows.enumerated().map { index, row in
            MenuBarEntry(
                index: index,
                title: copyValue(from: row, attribute: kAXTitleAttribute) as? String ?? "",
                isEnabled: copyValue(from: row, attribute: kAXEnabledAttribute) as? Bool ?? false,
                hasSubmenu: !(copyValue(from: row, attribute: kAXChildrenAttribute) as? [AXUIElement] ?? []).isEmpty
            )
        }
    }

    func invoke(_ entry: MenuBarEntry, in item: MenuBarItem) {
        guard let element = element(for: item) else { return }

        let rows = rows(of: element) ?? openedRows(of: element)
        guard entry.index < rows.count else { return }

        _ = AXUIElementPerformAction(rows[entry.index], kAXPressAction as CFString)
    }

    private func rows(of item: AXUIElement) -> [AXUIElement]? {
        guard let menu = (copyValue(from: item, attribute: kAXChildrenAttribute) as? [AXUIElement])?.first,
              let rows = copyValue(from: menu, attribute: kAXChildrenAttribute) as? [AXUIElement],
              !rows.isEmpty
        else {
            return nil
        }

        return rows
    }

    private func openedRows(of item: AXUIElement) -> [AXUIElement] {
        AXUIElementSetMessagingTimeout(item, TrayMetrics.pressTimeout)
        _ = AXUIElementPerformAction(item, kAXPressAction as CFString)

        let deadline = Date().addingTimeInterval(TrayMetrics.menuBuildAllowance)
        var found: [AXUIElement] = []
        while Date() < deadline, found.isEmpty {
            found = rows(of: item) ?? []
        }
        _ = AXUIElementPerformAction(item, TrayMetrics.cancelAction as CFString)

        return found
    }

    private func items(of application: NSRunningApplication) -> [MenuBarItem] {
        guard application.activationPolicy != .prohibited,
              MenuBarItemPolicy.isHostable(bundleIdentifier: application.bundleIdentifier)
        else {
            return []
        }

        return children(ofPid: application.processIdentifier).enumerated().map { index, element in
            MenuBarItem(
                ownerPid: application.processIdentifier,
                bundleIdentifier: application.bundleIdentifier,
                applicationName: application.localizedName ?? "",
                label: label(of: element),
                frame: frame(of: element),
                index: index
            )
        }
    }

    private func children(ofPid pid: pid_t) -> [AXUIElement] {
        let application = AXUIElementCreateApplication(pid)
        guard let extras = copyValue(from: application, attribute: TrayMetrics.extrasMenuBarAttribute) else {
            return []
        }
        let bar = extras as! AXUIElement

        return copyValue(from: bar, attribute: kAXChildrenAttribute) as? [AXUIElement] ?? []
    }

    private func element(for item: MenuBarItem) -> AXUIElement? {
        let elements = children(ofPid: item.ownerPid)
        guard item.index < elements.count else { return nil }

        return elements[item.index]
    }

    private func label(of element: AXUIElement) -> String? {
        let title = copyValue(from: element, attribute: kAXTitleAttribute) as? String
        if let title, !title.isEmpty { return title }

        let description = copyValue(from: element, attribute: kAXDescriptionAttribute) as? String

        return description.flatMap { $0.isEmpty ? nil : $0 }
    }

    private func frame(of element: AXUIElement) -> CGRect? {
        guard let positionValue = copyValue(from: element, attribute: kAXPositionAttribute),
              let sizeValue = copyValue(from: element, attribute: kAXSizeAttribute)
        else {
            return nil
        }
        var origin = CGPoint.zero
        var size = CGSize.zero
        guard AXValueGetValue(positionValue as! AXValue, .cgPoint, &origin),
              AXValueGetValue(sizeValue as! AXValue, .cgSize, &size),
              size.width > 0, size.height > 0
        else {
            return nil
        }

        return CGRect(origin: origin, size: size)
    }

    private func copyValue(from element: AXUIElement, attribute: String) -> CFTypeRef? {
        var value: CFTypeRef?
        guard AXUIElementCopyAttributeValue(element, attribute as CFString, &value) == .success else {
            return nil
        }
        return value
    }
}
