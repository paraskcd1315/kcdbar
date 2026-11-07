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

/** A click-through panel that covers one display with a peek's picture. */
package final class WindowPeekOverlayPanel: NSPanel {
    package override var canBecomeKey: Bool { false }
    package override var canBecomeMain: Bool { false }

    private var isDismissing = false

    package init(frame: NSRect) {
        super.init(
            contentRect: frame,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        isOpaque = true
        backgroundColor = .black
        hasShadow = false
        level = WindowPeekMetrics.overlayLevel
        collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        hidesOnDeactivate = false
        ignoresMouseEvents = true
        isReleasedWhenClosed = false
        alphaValue = 0
        let view = NSView(frame: NSRect(origin: .zero, size: frame.size))
        view.wantsLayer = true
        view.layer?.contentsGravity = .resize
        view.autoresizingMask = [.width, .height]
        contentView = view
    }

    package func present(_ image: CGImage, on frame: NSRect) {
        isDismissing = false
        setFrame(frame, display: false)
        contentView?.layer?.contents = image
        orderFrontRegardless()
        NSAnimationContext.runAnimationGroup { context in
            context.duration = WindowPeekMetrics.fadeIn
            animator().alphaValue = 1
        }
    }

    package func dismiss() {
        isDismissing = true
        NSAnimationContext.runAnimationGroup { context in
            context.duration = WindowPeekMetrics.fadeOut
            animator().alphaValue = 0
        } completionHandler: { [weak self] in
            MainActor.assumeIsolated {
                guard let self, self.isDismissing else { return }

                self.orderOut(nil)
                self.contentView?.layer?.contents = nil
            }
        }
    }
}
