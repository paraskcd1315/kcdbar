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
    private var frames: [Int: BarFrameState] = [:]
    private var visibility = BarPanelVisibilityState()
    private var notedReasons: [Int: String] = [:]
    private let presetState = BarPresetState(preset: BarPresetCatalogue.default)

    private let registry: WindowRegistry
    private let battery: BatteryMonitor
    private let trash: TrashMonitor
    private let timer: TimerMonitor
    private let totals: TotalsMonitor
    private let sessions: SessionsMonitor
    private let pins: PinnedAppState
    private let order: EntryOrderMemory
    private let desktop: ShowDesktopState
    private let icons: any ApplicationIconPort
    private let displaySource: any DisplayGeometryPort
    private let onActivate: (TaskbarEntryModel, Int) -> Void
    private let onRequestAccessibility: () -> Void
    private let onOpenStart: () -> Void
    private let onOpenSettings: () -> Void
    private let onOpenAbout: () -> Void
    private let onTogglePin: (TaskbarEntryModel) -> Void
    private let onCloseWindow: (TaskbarEntryModel) -> Void
    private let onQuit: (TaskbarEntryModel) -> Void
    private let onDropPin: (String, TaskbarEntryModel) -> Void
    private let onToggleDesktop: () -> Void
    private let onMiddleClick: (TaskbarEntryModel, Int) -> Void
    private let onOpenBattery: () -> Void
    private let onOpenNotifications: () -> Void
    private let onOpenControlCentre: () -> Void
    private let onOpenDay: () -> Void
    private let onOpenSessions: () -> Void

    package init(
        registry: WindowRegistry,
        battery: BatteryMonitor,
        trash: TrashMonitor,
        timer: TimerMonitor,
        totals: TotalsMonitor,
        sessions: SessionsMonitor,
        pins: PinnedAppState,
        order: EntryOrderMemory,
        desktop: ShowDesktopState,
        icons: any ApplicationIconPort,
        displaySource: any DisplayGeometryPort,
        onActivate: @escaping (TaskbarEntryModel, Int) -> Void,
        onRequestAccessibility: @escaping () -> Void,
        onOpenStart: @escaping () -> Void,
        onOpenSettings: @escaping () -> Void,
        onOpenAbout: @escaping () -> Void,
        onTogglePin: @escaping (TaskbarEntryModel) -> Void,
        onCloseWindow: @escaping (TaskbarEntryModel) -> Void,
        onQuit: @escaping (TaskbarEntryModel) -> Void,
        onDropPin: @escaping (String, TaskbarEntryModel) -> Void,
        onToggleDesktop: @escaping () -> Void,
        onMiddleClick: @escaping (TaskbarEntryModel, Int) -> Void,
        onOpenBattery: @escaping () -> Void,
        onOpenNotifications: @escaping () -> Void,
        onOpenControlCentre: @escaping () -> Void,
        onOpenDay: @escaping () -> Void,
        onOpenSessions: @escaping () -> Void
    ) {
        self.onOpenDay = onOpenDay
        self.onOpenSessions = onOpenSessions
        self.onOpenNotifications = onOpenNotifications
        self.onOpenControlCentre = onOpenControlCentre
        self.onDropPin = onDropPin
        self.onToggleDesktop = onToggleDesktop
        self.onMiddleClick = onMiddleClick
        self.onOpenBattery = onOpenBattery
        self.registry = registry
        self.battery = battery
        self.trash = trash
        self.timer = timer
        self.totals = totals
        self.sessions = sessions
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
        self.onOpenSettings = onOpenSettings
        self.onOpenAbout = onOpenAbout
    }

    package func present(preset: BarPreset) {
        presetState.apply(preset)
        rebuild(preset: preset)
        startClickThroughMonitors()

        guard screenObserver == nil else { return }

        screenObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            MainActor.assumeIsolated {
                guard let self else { return }

                self.rebuild(preset: self.presetState.preset)
            }
        }
    }

    package func syncVisibility() {
        var hidden: Set<Int> = []

        for id in panels.keys {
            let reason = BarVisibilityPolicy.reason(
                preset: presetState.preset,
                onDisplay: id,
                windows: registry.windows,
                displays: registry.displays
            )
            if reason != nil {
                hidden.insert(id)
            }
            note(reason: reason, for: id)
        }
        visibility.setHidden(hidden)

        for id in panels.keys {
            apply(showing: visibility.wantsShown(id), to: id)
        }
        updatePointerMonitor()
    }

    private func note(reason: BarVisibilityReason?, for id: Int) {
        let text = reason?.rawValue ?? "visible"
        guard notedReasons[id] != text else { return }

        notedReasons[id] = text
        BarLog.bar.notice("visibility display=\(id) reason=\(text, privacy: .public)")
    }

    private func apply(showing: Bool, to id: Int) {
        guard !visibility.isSettled(showing: showing, for: id) else { return }
        guard let panel = panels[id],
              let display = registry.displays.first(where: { $0.id == id })
        else {
            return
        }
        visibility.record(showing: showing, for: id)
        BarLog.bar.notice("panel display=\(id) showing=\(showing)")

        let settled = BarFrameCalculator.panelFrame(for: presetState.preset, on: display)
        let offEdge = BarRevealPolicy.concealedFrame(settled, edge: presetState.preset.edge)

        if showing {
            panel.setFrame(offEdge, display: false)
            panel.alphaValue = 0
            panel.orderFrontRegardless()
        }
        animate(panel, to: showing ? settled : offEdge, alpha: showing ? 1 : 0) { [weak self] in
            guard !showing else { return }
            guard self?.visibility.isSettled(showing: false, for: id) == true else { return }

            panel.orderOut(nil)
            panel.setFrame(settled, display: false)
            panel.alphaValue = 1
        }
    }

    private func animate(
        _ panel: BarPanel,
        to frame: NSRect,
        alpha: CGFloat,
        completion: @MainActor @escaping () -> Void
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
        if visibility.monitored(among: Set(panels.keys)).isEmpty {
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
                barRect: frames[id]?.frame,
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
        for id in visibility.monitored(among: Set(panels.keys)) {
            guard let display = registry.displays.first(where: { $0.id == id }) else { continue }

            let reveal = BarRevealPolicy.shouldReveal(
                pointer: location,
                barFrame: BarFrameCalculator.frame(for: presetState.preset, on: display),
                display: display,
                edge: presetState.preset.edge
            )
            visibility.setRevealed(reveal, for: id)
            apply(showing: visibility.wantsShown(id), to: id)
        }
        updatePointerMonitor()
    }

    package func dismiss() {
        stopPointerMonitor()
        stopClickThroughMonitors()
        visibility.reset()
        notedReasons = [:]
        frames = [:]
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
            visibility.forget(id)
            notedReasons.removeValue(forKey: id)
        }

        for display in displays {
            let frame = BarFrameCalculator.panelFrame(for: preset, on: display)
            if let existing = panels[display.id] {
                existing.setFrame(frame, display: true)
                continue
            }
            let frameState = frames[display.id] ?? BarFrameState()
            frames[display.id] = frameState
            let root = TaskbarRootView(
                registry: registry,
                pins: pins,
                order: order,
                desktop: desktop,
                presetState: presetState,
                displayId: display.id,
                icons: icons,
                onActivate: { [onActivate] in onActivate($0, display.id) },
                onRequestAccessibility: onRequestAccessibility,
                onOpenStart: onOpenStart,
                onOpenSettings: onOpenSettings,
                onOpenAbout: onOpenAbout,
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
                timer: timer,
                totals: totals,
                sessions: sessions,

                onOpenDay: onOpenDay,
                onOpenSessions: onOpenSessions,
                onBarFrameChange: { [frameState] in frameState.frame = $0 }
            )
            .environment(\.middleClickCatcher) { action in
                AnyView(MiddleClickView(action: action))
            }

            let panel = BarPanel(contentRect: frame)
            let host = BarHostingView(rootView: root)
            let rim = BarRimHostingView(
                rootView: TaskbarRimLayer(
                    presetState: presetState, frame: frameState, sessions: sessions))
            rim.sizingOptions = []
            rim.frame = host.bounds
            rim.autoresizingMask = [.width, .height]
            host.addSubview(rim)
            panel.contentView = host
            panel.orderFrontRegardless()
            panels[display.id] = panel
            visibility.record(showing: true, for: display.id)
        }
    }

    private func targetDisplays(for preset: BarPreset) -> [DisplayGeometry] {
        BarDisplaySelection.wanted(for: preset, among: displaySource.currentDisplays())
    }
}
