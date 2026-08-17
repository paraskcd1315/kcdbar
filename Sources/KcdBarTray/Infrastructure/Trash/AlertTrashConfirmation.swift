import AppKit

/** Asks about emptying the trash in a window of its own, never inside the bar's panel. */
@MainActor
package final class AlertTrashConfirmation: TrashConfirmationPort {
    package init() {}

    package func confirmEmpty() -> Bool {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = String(localized: "trash.confirm.title")
        alert.informativeText = String(localized: "trash.confirm.message")
        alert.addButton(withTitle: String(localized: "trash.confirm.empty"))
        alert.addButton(withTitle: String(localized: "trash.confirm.cancel"))
        alert.buttons.first?.hasDestructiveAction = true
        alert.window.level = .popUpMenu

        NSApp.activate(ignoringOtherApps: true)
        let answer = alert.runModal()
        NSApp.deactivate()

        return answer == .alertFirstButtonReturn
    }
}
