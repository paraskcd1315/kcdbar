import AppKit
import KcdBarDesignSystem
import SwiftUI

/** Hosts one popover panel, anchored above a bar item, growing upward from its lower edge. */
@MainActor
package final class PopoverHost {
    package init() {}

    private var panel: NSPanel?
    private var presentation: PopoverPresentation?
    private var dismissMonitor: Any?
    private var anchor: NSPoint = .zero
    private var isClosing = false

    package private(set) var presented: TrayPopover?

    package var isPresented: Bool {
        panel != nil && !isClosing
    }

    package func isPresenting(_ wanted: TrayPopover) -> Bool {
        isPresented && presented == wanted
    }

    package func present(
        _ key: TrayPopover,
        anchor: NSPoint,
        content: @escaping (PopoverPresentation, CGFloat) -> AnyView
    ) {
        closeImmediately()

        let presentation = PopoverPresentation()
        let size = fitted(NSHostingView(rootView: content(presentation, 0)).fittingSize, anchor: anchor)
        let settled = origin(for: size, anchor: anchor)

        let panel = makePanel()
        panel.setContentSize(size)
        panel.setFrameOrigin(settled)

        self.anchor = anchor
        self.panel = panel
        self.presentation = presentation
        self.presented = key

        let hosting = PopoverHostingView(
            rootView: content(presentation, anchor.x - settled.x)
        )
        hosting.onContentSizeChange = { [weak self] size in
            self?.resize(to: size)
        }
        panel.contentView = hosting
        panel.orderFrontRegardless()
        withAnimation(KbMotion.standard) { presentation.isExpanded = true }

        dismissMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: [.leftMouseDown, .rightMouseDown]
        ) { [weak self] _ in
            MainActor.assumeIsolated { self?.dismiss() }
        }
    }

    package func dismiss() {
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
            self.presented = nil
            self.isClosing = false
        }
    }

    private func resize(to size: CGSize) {
        guard let panel, !isClosing, size.width > 0, size.height > 0 else { return }

        let wanted = fitted(size, anchor: anchor)
        guard panel.frame.size != wanted else { return }

        let settled = origin(for: wanted, anchor: anchor)
        panel.setFrame(NSRect(origin: settled, size: wanted), display: true)
    }

    private func closeImmediately() {
        stopMonitor()
        panel?.orderOut(nil)
        panel = nil
        presentation = nil
        presented = nil
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
        PopoverAnchor.origin(for: size, anchor: anchor, within: bounds(containing: anchor))
    }

    private func fitted(_ size: NSSize, anchor: NSPoint) -> NSSize {
        PopoverAnchor.fittedSize(size, anchor: anchor, within: bounds(containing: anchor))
    }

    private func bounds(containing anchor: NSPoint) -> CGRect {
        let screen = NSScreen.screens.first { $0.frame.contains(anchor) } ?? NSScreen.main

        return screen?.visibleFrame ?? .zero
    }
}
