import AppKit
import KcdBarDesignSystem
import KcdBarTray
import SwiftUI

@MainActor
package final class BarPanelHost: BarPanelHostPort {
    private var panels: [Int: BarPanel] = [:]
    private var screenObserver: NSObjectProtocol?
    private var pointerMonitor: Any?
    private var clickThroughMonitors: [Any] = []
    private var hitRegions: [Int: BarHitRegion] = [:]
    private var hiddenDisplays: Set<Int> = []
    private var revealedDisplays: Set<Int> = []
    private var shown: [Int: Bool] = [:]
    private var activePreset = BarPresetCatalogue.default

    private let registry: WindowRegistry
    private let battery: BatteryMonitor
    private let trash: TrashMonitor
    private let pins: PinnedAppState
    private let order: EntryOrderMemory
    private let desktop: ShowDesktopState
    private let icons: any ApplicationIconPort
    private let displaySource: any DisplayGeometryPort
    private let onActivate: (TaskbarEntryModel, Int) -> Void
    private let onRequestAccessibility: () -> Void
    private let onOpenStart: () -> Void
    private let onTogglePin: (TaskbarEntryModel) -> Void
    private let onCloseWindow: (TaskbarEntryModel) -> Void
    private let onQuit: (TaskbarEntryModel) -> Void
    private let onDropPin: (String, TaskbarEntryModel) -> Void
    private let onToggleDesktop: () -> Void
    private let onMiddleClick: (TaskbarEntryModel, Int) -> Void
    private let onOpenBattery: () -> Void
    private let onOpenNotifications: () -> Void
    private let onOpenControlCentre: () -> Void

    package init(
        registry: WindowRegistry,
        battery: BatteryMonitor,
        trash: TrashMonitor,
        pins: PinnedAppState,
        order: EntryOrderMemory,
        desktop: ShowDesktopState,
        icons: any ApplicationIconPort,
        displaySource: any DisplayGeometryPort,
        onActivate: @escaping (TaskbarEntryModel, Int) -> Void,
        onRequestAccessibility: @escaping () -> Void,
        onOpenStart: @escaping () -> Void,
        onTogglePin: @escaping (TaskbarEntryModel) -> Void,
        onCloseWindow: @escaping (TaskbarEntryModel) -> Void,
        onQuit: @escaping (TaskbarEntryModel) -> Void,
        onDropPin: @escaping (String, TaskbarEntryModel) -> Void,
        onToggleDesktop: @escaping () -> Void,
        onMiddleClick: @escaping (TaskbarEntryModel, Int) -> Void,
        onOpenBattery: @escaping () -> Void,
        onOpenNotifications: @escaping () -> Void,
        onOpenControlCentre: @escaping () -> Void
    ) {
        self.onOpenNotifications = onOpenNotifications
        self.onOpenControlCentre = onOpenControlCentre
        self.onDropPin = onDropPin
        self.onToggleDesktop = onToggleDesktop
        self.onMiddleClick = onMiddleClick
        self.onOpenBattery = onOpenBattery
        self.registry = registry
        self.battery = battery
        self.trash = trash
        self.pins = pins
        self.order = order
        self.desktop = desktop
        self.icons = icons
        self.onTogglePin = onTogglePin
        self.onCloseWindow = onCloseWindow
        self.onQuit = onQuit
        self.displaySource = displaySource
        self.onActivate = onActivate
        self.onRequestAccessibility = onRequestAccessibility
        self.onOpenStart = onOpenStart
    }

    package func present(preset: BarPreset) {
        activePreset = preset
        rebuild(preset: preset)
        startClickThroughMonitors()
        screenObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            MainActor.assumeIsolated { self?.rebuild(preset: preset) }
        }
    }

    package func syncVisibility() {
        hiddenDisplays = Set(
            panels.keys.filter { id in
                BarVisibilityPolicy.isHidden(
                    onDisplay: id,
                    windows: registry.windows,
                    displays: registry.displays
                )
            }
        )
        revealedDisplays.formIntersection(hiddenDisplays)

        for id in panels.keys {
            apply(showing: !hiddenDisplays.contains(id) || revealedDisplays.contains(id), to: id)
        }
        updatePointerMonitor()
    }

    private func apply(showing: Bool, to id: Int) {
        guard shown[id] != showing else { return }
        guard let panel = panels[id],
              let display = registry.displays.first(where: { $0.id == id })
        else {
            return
        }
        shown[id] = showing

        let settled = BarFrameCalculator.panelFrame(for: activePreset, on: display)
        let offEdge = BarRevealPolicy.concealedFrame(settled, edge: activePreset.edge)

        if showing {
            panel.setFrame(offEdge, display: false)
            panel.alphaValue = 0
            panel.orderFrontRegardless()
        }
        animate(panel, to: showing ? settled : offEdge, alpha: showing ? 1 : 0) {
            guard !showing else { return }
            panel.orderOut(nil)
            panel.setFrame(settled, display: false)
            panel.alphaValue = 1
        }
    }

    private func animate(
        _ panel: BarPanel,
        to frame: NSRect,
        alpha: CGFloat,
        completion: @escaping () -> Void
    ) {
        NSAnimationContext.runAnimationGroup { context in
            context.duration = KbMotion.standardDuration
            context.timingFunction = CAMediaTimingFunction(
                controlPoints: KbMotion.curve.x1, KbMotion.curve.y1, KbMotion.curve.x2, KbMotion.curve.y2
            )
            panel.animator().setFrame(frame, display: true)
            panel.animator().alphaValue = alpha
        } completionHandler: {
            MainActor.assumeIsolated(completion)
        }
    }

    private func updatePointerMonitor() {
        if hiddenDisplays.isEmpty {
            stopPointerMonitor()
            return
        }
        guard pointerMonitor == nil else { return }

        pointerMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { [weak self] _ in
            MainActor.assumeIsolated { self?.pointerMoved(to: NSEvent.mouseLocation) }
        }
    }

    private func startClickThroughMonitors() {
        guard clickThroughMonitors.isEmpty else { return }

        let events: NSEvent.EventTypeMask = [.mouseMoved, .leftMouseDragged, .rightMouseDragged]
        if let global = NSEvent.addGlobalMonitorForEvents(matching: events) { [weak self] _ in
            MainActor.assumeIsolated { self?.updateClickThrough(at: NSEvent.mouseLocation) }
        } {
            clickThroughMonitors.append(global)
        }
        if let local = NSEvent.addLocalMonitorForEvents(matching: events) { [weak self] event in
            MainActor.assumeIsolated { self?.updateClickThrough(at: NSEvent.mouseLocation) }
            return event
        } {
            clickThroughMonitors.append(local)
        }
    }

    private func stopClickThroughMonitors() {
        for monitor in clickThroughMonitors {
            NSEvent.removeMonitor(monitor)
        }
        clickThroughMonitors = []
    }

    private func updateClickThrough(at point: NSPoint) {
        for (id, panel) in panels {
            panel.ignoresMouseEvents = BarHitTesting.passesThrough(
                point,
                barRect: hitRegions[id]?.rect,
                panelFrame: panel.frame
            )
        }
    }

    private func stopPointerMonitor() {
        if let pointerMonitor {
            NSEvent.removeMonitor(pointerMonitor)
        }
        pointerMonitor = nil
    }

    private func pointerMoved(to location: NSPoint) {
        for id in hiddenDisplays {
            guard let display = registry.displays.first(where: { $0.id == id }) else { continue }

            let reveal = BarRevealPolicy.shouldReveal(
                pointer: location,
                barFrame: BarFrameCalculator.panelFrame(for: activePreset, on: display),
                display: display,
                edge: activePreset.edge
            )
            guard reveal != revealedDisplays.contains(id) else { continue }

            if reveal {
                revealedDisplays.insert(id)
            } else {
                revealedDisplays.remove(id)
            }
            apply(showing: reveal, to: id)
        }
    }

    package func dismiss() {
        stopPointerMonitor()
        stopClickThroughMonitors()
        hiddenDisplays = []
        revealedDisplays = []
        shown = [:]
        hitRegions = [:]
        panels.values.forEach { $0.orderOut(nil) }
        panels = [:]
        if let screenObserver {
            NotificationCenter.default.removeObserver(screenObserver)
        }
        screenObserver = nil
    }

    private func rebuild(preset: BarPreset) {
        let displays = targetDisplays(for: preset)
        let wanted = Set(displays.map(\.id))

        for (id, panel) in panels where !wanted.contains(id) {
            panel.orderOut(nil)
            panels.removeValue(forKey: id)
            shown.removeValue(forKey: id)
        }

        for display in displays {
            let frame = BarFrameCalculator.panelFrame(for: preset, on: display)
            if let existing = panels[display.id] {
                existing.setFrame(frame, display: true)
                continue
            }
            let hitRegion = hitRegions[display.id] ?? BarHitRegion()
            hitRegions[display.id] = hitRegion
            let root = TaskbarRootView(
                registry: registry,
                pins: pins,
                order: order,
                desktop: desktop,
                preset: preset,
                displayId: display.id,
                icons: icons,
                onActivate: { [onActivate] in onActivate($0, display.id) },
                onRequestAccessibility: onRequestAccessibility,
                onOpenStart: onOpenStart,
                onTogglePin: onTogglePin,
                onCloseWindow: onCloseWindow,
                onQuit: onQuit,
                onDropPin: onDropPin,
                onToggleDesktop: onToggleDesktop,
                onMiddleClick: { [onMiddleClick] in onMiddleClick($0, display.id) },
                battery: battery,
                onOpenBattery: onOpenBattery,
                onOpenNotifications: onOpenNotifications,
                onOpenControlCentre: onOpenControlCentre,
                trash: trash,
                onBarFrameChange: { [hitRegion] in hitRegion.rect = $0 }
            )
            .environment(\.middleClickCatcher) { action in
                AnyView(MiddleClickView(action: action))
            }

            let panel = BarPanel(contentRect: frame)
            panel.contentView = BarHostingView(rootView: root)
            panel.orderFrontRegardless()
            panels[display.id] = panel
            shown[display.id] = true
        }
    }

    private func targetDisplays(for preset: BarPreset) -> [DisplayGeometry] {
        BarDisplaySelection.wanted(for: preset, among: displaySource.currentDisplays())
    }
}
