import AppKit

/** Puts text on the general pasteboard. */
@MainActor
package struct AppKitPasteboard: PasteboardPort {
    package init() {}

    package func copy(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
}
