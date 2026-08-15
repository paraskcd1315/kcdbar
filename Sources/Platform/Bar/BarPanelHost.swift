import AppKit
import SwiftUI

@MainActor
final class BarPanelHost: BarPanelHostPort {
    private var panels: [Int: BarPanel] = [:]
    private var screenObserver: NSObjectProtocol?
    private var pointerMonitor: Any?
    private var hiddenDisplays: Set<Int> = []
    private var revealedDisplays: Set<Int> = []
    private var shown: [Int: Bool] = [:]
    private var activePreset = BarPresetCatalogue.default

    private let registry: WindowRegistry
    private let tray: MenuBarItemRegistry
    private let pins: PinnedAppState
    private let order: EntryOrderMemory
    private let desktop: ShowDesktopState
    private let icons: any ApplicationIconPort
    private let trayIcons: any MenuBarIconPort
    private let displaySource: any DisplayGeometryPort
    private let onActivate: (TaskbarEntryModel, Int) -> Void
    private let onRequestAccessibility: () -> Void
    private let onOpenStart: () -> Void
    private let onTogglePin: (TaskbarEntryModel) -> Void
    private let onDropPin: (String, TaskbarEntryModel) -> Void
    private let onToggleDesktop: () -> Void
    private let onMiddleClick: (TaskbarEntryModel, Int) -> Void
    private let onPressTrayItem: (TrayItemModel) -> Void

    init(
        registry: WindowRegistry,
        tray: MenuBarItemRegistry,
        pins: PinnedAppState,
        order: EntryOrderMemory,
        desktop: ShowDesktopState,
        icons: any ApplicationIconPort,
        trayIcons: any MenuBarIconPort,
        displaySource: any DisplayGeometryPort,
        onActivate: @escaping (TaskbarEntryModel, Int) -> Void,
        onRequestAccessibility: @escaping () -> Void,
        onOpenStart: @escaping () -> Void,
        onTogglePin: @escaping (TaskbarEntryModel) -> Void,
        onDropPin: @escaping (String, TaskbarEntryModel) -> Void,
        onToggleDesktop: @escaping () -> Void,
        onMiddleClick: @escaping (TaskbarEntryModel, Int) -> Void,
        onPressTrayItem: @escaping (TrayItemModel) -> Void
    ) {
        self.onDropPin = onDropPin
        self.onToggleDesktop = onToggleDesktop
        self.onMiddleClick = onMiddleClick
        self.onPressTrayItem = onPressTrayItem
        self.registry = registry
        self.tray = tray
        self.pins = pins
        self.order = order
        self.desktop = desktop
        self.icons = icons
        self.trayIcons = trayIcons
        self.onTogglePin = onTogglePin
        self.displaySource = displaySource
        self.onActivate = onActivate
        self.onRequestAccessibility = onRequestAccessibility
        self.onOpenStart = onOpenStart
    }

    func present(preset: BarPreset) {
        activePreset = preset
        rebuild(preset: preset)
        screenObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            MainActor.assumeIsolated { self?.rebuild(preset: preset) }
        }
    }

    func syncVisibility() {
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

    func dismiss() {
        stopPointerMonitor()
        hiddenDisplays = []
        revealedDisplays = []
        shown = [:]
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
            let root = TaskbarRootView(
                registry: registry,
                tray: tray,
                pins: pins,
                order: order,
                desktop: desktop,
                preset: preset,
                displayId: display.id,
                icons: icons,
                trayIcons: trayIcons,
                onActivate: { [onActivate] in onActivate($0, display.id) },
                onRequestAccessibility: onRequestAccessibility,
                onOpenStart: onOpenStart,
                onTogglePin: onTogglePin,
                onDropPin: onDropPin,
                onToggleDesktop: onToggleDesktop,
                onMiddleClick: { [onMiddleClick] in onMiddleClick($0, display.id) },
                onPressTrayItem: onPressTrayItem
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
        let displays = displaySource.currentDisplays()
        switch preset.displays {
        case .primaryOnly: return displays.filter(\.isPrimary)
        case .allDisplays, .chosenDisplays: return displays
        }
    }
}
