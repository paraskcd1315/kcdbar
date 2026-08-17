import AppKit

/** Lends the panel key status while a field is open. */
@MainActor
package struct AppKitPanelTextEditing: PanelTextEditingPort {
    package init() {}

    package func beginEditing() {
        NSApp.activate(ignoringOtherApps: true)
        editable?.makeKeyAndOrderFront(nil)
    }

    package func endEditing() {
        editable?.resignKey()
        NSApp.deactivate()
    }

    private var editable: NSPanel? {
        NSApp.windows
            .compactMap { $0 as? NSPanel }
            .first { $0.isVisible && $0.canBecomeKey }
    }
}
