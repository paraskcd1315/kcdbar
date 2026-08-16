import AppKit

/** Lends the panel key status while a field is open. */
@MainActor
package struct AppKitPanelTextEditing: PanelTextEditingPort {
    package init() {}

    package func beginEditing() {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.keyWindow?.makeFirstResponder(nil)
    }

    package func endEditing() {
        NSApp.deactivate()
    }
}
