import AppKit
import SwiftUI

/** Hosts one popover panel, anchored above a bar item, growing upward from its lower edge. */
@MainActor
final class PopoverHost {
    private var panel: NSPanel?
    private var presentation: PopoverPresentation?
    private var dismissMonitor: Any?
    private var anchor: NSPoint = .zero
    private var isClosing = false

    var isPresented: Bool {
        panel != nil && !isClosing
    }

    func present(
        anchor: NSPoint,
        content: @escaping (PopoverPresentation, CGFloat) -> AnyView
    ) {
        closeImmediately()

        let presentation = PopoverPresentation()
        let size = NSHostingView(rootView: content(presentation, 0)).fittingSize
        let settled = origin(for: size, anchor: anchor)

        let panel = makePanel()
        panel.setContentSize(size)
        panel.setFrameOrigin(settled)
        panel.contentView = NSHostingView(
            rootView: measured(content(presentation, anchor.x - settled.x))
        )
        panel.orderFrontRegardless()

        self.anchor = anchor
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
            try? await Task.sleep(for: .milliseconds(KbPopoverMetrics.collapseMilliseconds))
            panel.orderOut(nil)
            guard let self, self.panel === panel else { return }
            self.panel = nil
            self.presentation = nil
            self.isClosing = false
        }
    }

    private func measured(_ content: AnyView) -> AnyView {
        AnyView(
            content.onGeometryChange(for: CGSize.self) { proxy in
                proxy.size
            } action: { [weak self] size in
                self?.resize(to: size)
            }
        )
    }

    private func resize(to size: CGSize) {
        guard let panel, !isClosing, size.width > 0, size.height > 0 else { return }
        guard panel.frame.size != size else { return }

        let settled = origin(for: size, anchor: anchor)
        panel.setFrame(NSRect(origin: settled, size: size), display: true)
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
        let bounds = screen?.visibleFrame ?? .zero
        let x = min(max(anchor.x - size.width / 2, bounds.minX), bounds.maxX - size.width)
        let y = min(anchor.y + KbPopoverMetrics.gap, bounds.maxY - size.height)

        return NSPoint(x: x, y: max(y, bounds.minY))
    }
}
