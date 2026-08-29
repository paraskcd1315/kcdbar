// Copyright 2026 Paras Mohandas Khanchandani Chandani
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
    private var takesFocus = false

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
        takesFocus: Bool = false,
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
                .environment(\.popoverRoom, room(above: anchor))
        )
        hosting.onContentSizeChange = { [weak self] size in
            self?.resize(to: size)
        }
        panel.contentView = hosting
        panel.orderFrontRegardless()
        if takesFocus {
            self.takesFocus = true
            NSApp.activate(ignoringOtherApps: true)
            panel.makeKeyAndOrderFront(nil)
        }
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
        releaseFocus()
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
        let frame = NSRect(origin: settled, size: wanted)

        NSAnimationContext.runAnimationGroup { context in
            context.duration = KbMotion.standardDuration
            context.timingFunction = CAMediaTimingFunction(
                controlPoints: KbMotion.curve.x1, KbMotion.curve.y1, KbMotion.curve.x2, KbMotion.curve.y2
            )
            panel.animator().setFrame(frame, display: true)
        }
    }

    private func releaseFocus() {
        guard takesFocus else { return }
        takesFocus = false
        NSApp.deactivate()
    }

    private func closeImmediately() {
        stopMonitor()
        releaseFocus()
        panel?.orderOut(nil)
        panel = nil
        presentation = nil
        presented = nil
        isClosing = false
    }

    private func makePanel() -> NSPanel {
        let panel = PopoverPanel(
            contentRect: .zero,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        panel.isOpaque = false
        panel.backgroundColor = .black.withAlphaComponent(KbPopoverMetrics.hitTestAlpha)
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

    private func room(above anchor: NSPoint) -> CGFloat {
        let within = bounds(containing: anchor)

        return max(within.maxY - (anchor.y + PopoverPlacementMetrics.gap), 0)
    }

    private func bounds(containing anchor: NSPoint) -> CGRect {
        let screen = NSScreen.screens.first { $0.frame.contains(anchor) } ?? NSScreen.main

        return screen?.visibleFrame ?? .zero
    }
}
