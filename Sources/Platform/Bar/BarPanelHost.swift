import AppKit
import SwiftUI

@MainActor
final class BarPanelHost: BarPanelHostPort {
    private var panels: [Int: BarPanel] = [:]
    private var screenObserver: NSObjectProtocol?

    private let registry: WindowRegistry
    private let pins: PinnedAppState
    private let order: EntryOrderMemory
    private let desktop: ShowDesktopState
    private let icons: any ApplicationIconPort
    private let displaySource: any DisplayGeometryPort
    private let onActivate: (TaskbarEntryModel, Int) -> Void
    private let onRequestAccessibility: () -> Void
    private let onOpenStart: () -> Void
    private let onTogglePin: (TaskbarEntryModel) -> Void
    private let onDropPin: (String, TaskbarEntryModel) -> Void
    private let onToggleDesktop: () -> Void
    private let onMiddleClick: (TaskbarEntryModel, Int) -> Void

    init(
        registry: WindowRegistry,
        pins: PinnedAppState,
        order: EntryOrderMemory,
        desktop: ShowDesktopState,
        icons: any ApplicationIconPort,
        displaySource: any DisplayGeometryPort,
        onActivate: @escaping (TaskbarEntryModel, Int) -> Void,
        onRequestAccessibility: @escaping () -> Void,
        onOpenStart: @escaping () -> Void,
        onTogglePin: @escaping (TaskbarEntryModel) -> Void,
        onDropPin: @escaping (String, TaskbarEntryModel) -> Void,
        onToggleDesktop: @escaping () -> Void,
        onMiddleClick: @escaping (TaskbarEntryModel, Int) -> Void
    ) {
        self.onDropPin = onDropPin
        self.onToggleDesktop = onToggleDesktop
        self.onMiddleClick = onMiddleClick
        self.registry = registry
        self.pins = pins
        self.order = order
        self.desktop = desktop
        self.icons = icons
        self.onTogglePin = onTogglePin
        self.displaySource = displaySource
        self.onActivate = onActivate
        self.onRequestAccessibility = onRequestAccessibility
        self.onOpenStart = onOpenStart
    }

    func present(preset: BarPreset) {
        rebuild(preset: preset)
        screenObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            MainActor.assumeIsolated { self?.rebuild(preset: preset) }
        }
    }

    func dismiss() {
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
        }

        for display in displays {
            let frame = BarFrameCalculator.panelFrame(for: preset, on: display)
            if let existing = panels[display.id] {
                existing.setFrame(frame, display: true)
                continue
            }
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
                onDropPin: onDropPin,
                onToggleDesktop: onToggleDesktop,
                onMiddleClick: { [onMiddleClick] in onMiddleClick($0, display.id) }
            )
            .environment(\.middleClickCatcher) { action in
                AnyView(MiddleClickView(action: action))
            }

            let panel = BarPanel(contentRect: frame)
            panel.contentView = BarHostingView(rootView: root)
            panel.orderFrontRegardless()
            panels[display.id] = panel
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
