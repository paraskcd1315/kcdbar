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
import IOSurface

/** A click-through panel that covers one display with a live peek and its window outlines. */
package final class WindowPeekOverlayPanel: NSPanel {
    package override var canBecomeKey: Bool { false }
    package override var canBecomeMain: Bool { false }

    private let outlines = CALayer()
    private var scene: WindowPeekScene?
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
        view.layer?.addSublayer(outlines)
        view.autoresizingMask = [.width, .height]
        contentView = view
    }

    package func display(_ surface: IOSurfaceRef, scene: WindowPeekScene, on frame: NSRect) {
        if self.scene != scene || self.frame != frame {
            setFrame(frame, display: false)
            draw(scene, in: frame)
            self.scene = scene
        }
        contentView?.layer?.contents = surface
        guard isDismissing || !isVisible else { return }

        isDismissing = false
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
                self.scene = nil
            }
        }
    }

    private func draw(_ scene: WindowPeekScene, in frame: NSRect) {
        let bounds = CGRect(origin: .zero, size: frame.size)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        outlines.frame = bounds
        outlines.sublayers = scene.outlines.map { outline(local($0, in: frame)) }
        outlines.mask = scene.peeked.map { hole(local($0, in: frame), in: bounds) }
        CATransaction.commit()
    }

    private func local(_ rect: CGRect, in frame: NSRect) -> CGRect {
        rect.offsetBy(dx: -frame.minX, dy: -frame.minY)
    }

    private func outline(_ rect: CGRect) -> CALayer {
        let layer = CALayer()
        layer.frame = rect
        layer.cornerRadius = WindowPeekMetrics.outlineCornerRadius
        layer.cornerCurve = .continuous
        layer.borderWidth = WindowPeekMetrics.outlineBorderWidth
        layer.borderColor = WindowPeekMetrics.outlineBorder
        layer.backgroundColor = WindowPeekMetrics.outlineFill

        return layer
    }

    private func hole(_ rect: CGRect, in bounds: CGRect) -> CALayer {
        let path = CGMutablePath()
        path.addRect(bounds)
        path.addRect(rect)
        let mask = CAShapeLayer()
        mask.frame = bounds
        mask.path = path
        mask.fillRule = .evenOdd

        return mask
    }
}
