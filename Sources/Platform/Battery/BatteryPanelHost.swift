import AppKit
import SwiftUI

@MainActor
final class BatteryPanelHost {
    private var panel: NSPanel?
    private var presentation: BatteryPanelPresentation?
    private var dismissMonitor: Any?
    private var isClosing = false

    var isPresented: Bool {
        panel != nil && !isClosing
    }

    func present(state: BatteryState, energyUsers: [EnergyUser], anchor: NSPoint) {
        closeImmediately()

        let presentation = BatteryPanelPresentation()
        let sizing = NSHostingView(
            rootView: BatteryPanelView(
                state: state,
                energyUsers: energyUsers,
                arrowX: 0,
                presentation: presentation
            )
        )
        let size = sizing.fittingSize
        let settled = origin(for: size, anchor: anchor)

        let panel = makePanel()
        panel.contentView = NSHostingView(
            rootView: BatteryPanelView(
                state: state,
                energyUsers: energyUsers,
                arrowX: anchor.x - settled.x,
                presentation: presentation
            )
        )
        panel.setContentSize(size)
        panel.setFrameOrigin(settled)
        panel.orderFrontRegardless()

        self.panel = panel
        self.presentation = presentation
        withAnimation(KbMotion.standard) { presentation.isExpanded = true }

        dismissMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: [.leftMouseDown, .rightMouseDown]
        ) { [weak self] _ in
            MainActor.assumeIsolated { self?.dismiss() }
        }
    }

    func dismiss() {
        guard let panel, let presentation, !isClosing else { return }

        stopMonitor()
        isClosing = true
        withAnimation(KbMotion.standard) { presentation.isExpanded = false }

        Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(BatteryMetrics.collapseMilliseconds))
            panel.orderOut(nil)
            guard let self, self.panel === panel else { return }
            self.panel = nil
            self.presentation = nil
            self.isClosing = false
        }
    }

    private func closeImmediately() {
        stopMonitor()
        panel?.orderOut(nil)
        panel = nil
        presentation = nil
        isClosing = false
    }

    private func makePanel() -> NSPanel {
        let panel = NSPanel(
            contentRect: .zero,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = false
        panel.level = .popUpMenu
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
        panel.hidesOnDeactivate = false

        return panel
    }

    private func stopMonitor() {
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
