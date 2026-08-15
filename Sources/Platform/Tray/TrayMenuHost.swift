import AppKit
import SwiftUI

@MainActor
final class TrayMenuHost {
    private var panel: TrayMenuPanel?
    private var dismissMonitor: Any?

    func present(
        title: String,
        entries: [MenuBarEntry],
        anchor: NSPoint,
        onSelect: @escaping (MenuBarEntry) -> Void
    ) {
        dismiss()
        guard !entries.isEmpty else { return }

        let panel = TrayMenuPanel()
        panel.contentView = NSHostingView(
            rootView: TrayMenuView(title: title, entries: entries) { [weak self] entry in
                self?.dismiss()
                onSelect(entry)
            }
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
        let y = anchor.y + TrayMetrics.menuGap

        return NSPoint(x: x, y: min(y, bounds.maxY - size.height))
    }
}
