import AppKit
import SwiftUI

@MainActor
final class BatteryPanelHost {
    private var panel: NSPanel?
    private var dismissMonitor: Any?

    func present(state: BatteryState, energyUsers: [EnergyUser], anchor: NSPoint) {
        dismiss()

        let panel = NSPanel(
            contentRect: .zero,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = true
        panel.level = .popUpMenu
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
        panel.hidesOnDeactivate = false
        panel.contentView = NSHostingView(
            rootView: BatteryPanelView(state: state, energyUsers: energyUsers)
        )
        panel.setContentSize(panel.contentView?.fittingSize ?? .zero)
        panel.setFrameOrigin(origin(for: panel.frame.size, anchor: anchor))
        panel.orderFrontRegardless()
        self.panel = panel

        dismissMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: [.leftMouseDown, .rightMouseDown]
        ) { [weak self] _ in
            MainActor.assumeIsolated { self?.dismiss() }
        }
    }

    func dismiss() {
        panel?.orderOut(nil)
        panel = nil
        if let dismissMonitor {
            NSEvent.removeMonitor(dismissMonitor)
        }
        dismissMonitor = nil
    }

    private func origin(for size: NSSize, anchor: NSPoint) -> NSPoint {
        let screen = NSScreen.screens.first { $0.frame.contains(anchor) } ?? NSScreen.main
        let bounds = screen?.frame ?? .zero
        let x = min(max(anchor.x - size.width / 2, bounds.minX), bounds.maxX - size.width)

        return NSPoint(x: x, y: min(anchor.y + BatteryMetrics.panelGap, bounds.maxY - size.height))
    }
}
