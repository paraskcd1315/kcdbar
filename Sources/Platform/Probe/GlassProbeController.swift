import AppKit
import SwiftUI

@MainActor
final class GlassProbeController {
    private var panel: BarPanel?
    private var window: NSWindow?

    func present() {
        guard let screen = NSScreen.main else { return }
        presentPanel(on: screen)
        presentWindow(on: screen)
    }

    private func presentPanel(on screen: NSScreen) {
        let size = GlassProbeMetrics.surfaceSize
        let frame = NSRect(
            x: screen.frame.midX - size.width - GlassProbeMetrics.gap,
            y: screen.frame.midY - size.height / 2,
            width: size.width,
            height: size.height
        )
        let panel = BarPanel(contentRect: frame)
        panel.contentView = NSHostingView(rootView: GlassProbeView(surface: .borderlessPanel))
        panel.orderFrontRegardless()
        self.panel = panel
    }

    private func presentWindow(on screen: NSScreen) {
        let size = GlassProbeMetrics.surfaceSize
        let frame = NSRect(
            x: screen.frame.midX + GlassProbeMetrics.gap,
            y: screen.frame.midY - size.height / 2,
            width: size.width,
            height: size.height
        )
        let window = NSWindow(
            contentRect: frame,
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.title = GlassProbeMetrics.windowTitle
        window.contentView = NSHostingView(rootView: GlassProbeView(surface: .ordinaryWindow))
        window.makeKeyAndOrderFront(nil)
        self.window = window
    }
}
