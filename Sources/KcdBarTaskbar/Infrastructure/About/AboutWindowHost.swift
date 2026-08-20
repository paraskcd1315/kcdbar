import AppKit
import SwiftUI

/** Holds the one About window. */
@MainActor
package final class AboutWindowHost: NSObject, NSWindowDelegate {
    private var window: NSWindow?
    private let version: AppVersionPort

    package init(version: AppVersionPort = BundleAppVersionSource()) {
        self.version = version
        super.init()
    }

    package func present() {
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
                width: AboutMetrics.windowWidth,
                height: AboutMetrics.windowHeight
            ),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        created.title = String(localized: "about.title")
        created.contentView = NSHostingView(
            rootView: AboutView(
                version: version.current,
                icon: Image(nsImage: NSApp.applicationIconImage)
            )
        )
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
