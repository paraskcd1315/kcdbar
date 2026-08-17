import AppKit
import SwiftUI

/** Holds the one settings window, and the regular activation policy it needs to take the keyboard. */
@MainActor
package final class SettingsWindowHost: NSObject, NSWindowDelegate {
    private var window: NSWindow?

    package override init() {
        super.init()
    }

    package func present<Content: View>(@ViewBuilder content: () -> Content) {
        NSApp.setActivationPolicy(.regular)

        if let window {
            NSApp.activate(ignoringOtherApps: true)
            window.makeKeyAndOrderFront(nil)

            return
        }

        let created = NSWindow(
            contentRect: NSRect(
                x: 0,
                y: 0,
                width: SettingsMetrics.windowWidth,
                height: SettingsMetrics.windowHeight
            ),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        created.title = String(localized: "settings.title")
        created.contentView = NSHostingView(rootView: content())
        created.isReleasedWhenClosed = false
        created.delegate = self
        created.center()
        window = created

        NSApp.activate(ignoringOtherApps: true)
        created.makeKeyAndOrderFront(nil)
    }

    package func windowWillClose(_ notification: Notification) {
        window = nil
        NSApp.setActivationPolicy(.accessory)
    }
}
