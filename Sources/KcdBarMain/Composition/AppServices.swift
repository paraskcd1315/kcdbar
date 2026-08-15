import AppKit
import Foundation
import KcdBarBar
import KcdBarPreferences
import KcdBarTray
import SwiftUI

/** The composition root, and the only place naming a concrete platform implementation. */
@MainActor
package final class AppServices {
    package let icons: any ApplicationIconPort = WorkspaceIconSource()
    package let displays: any DisplayGeometryPort = ScreenGeometrySource()
    package let authorization: any AccessibilityAuthorizationPort = AccessibilityAuthorization()
    package let changes: any WindowChangeObserverPort = WorkspaceWindowChangeObserver()
    package let registry: WindowRegistry
    package let battery = BatteryMonitor(source: IoKitBatterySource())
    package let batteryPanel = PopoverHost()
    package let controlCentrePanel = PopoverHost()
    package let wifi = WifiMonitor(source: CoreWlanSource())
    package let bluetooth = BluetoothMonitor(source: IoBluetoothSource())
    package let sound = SoundMonitor(source: CoreAudioSoundSource())
    package let brightness = BrightnessMonitor(source: DisplayServicesBrightness())
    package let pins: PinnedAppState
    package let order = EntryOrderMemory()
    package let desktop = ShowDesktopState()
    package let showDesktop: any ShowDesktopPort = CoreDockShowDesktop()
    package let launcher: any ApplicationLaunchPort = WorkspaceApplicationLauncher()
    package let newWindow: any NewWindowPort = AccessibilityNewWindow()

    package let control: any WindowControlPort = AccessibilityWindowControl()
    package let geometry: any WindowGeometryObserverPort = AccessibilityGeometryObserver()
    private lazy var overlap = WindowOverlapEnforcer(control: control)
    private var activePreset = BarPresetCatalogue.default
    private lazy var coalesced = CoalescedTrigger(
        interval: WindowOverlapMetrics.coalesceInterval
    ) { [weak self] in
        self?.refreshAndEnforce()
    }

    package private(set) var bar: (any BarPanelHostPort)?

    package func scheduleRefresh() {
        coalesced.fire()
    }

    package func refreshAndEnforce(now: Date = Date()) {
        registry.refresh()
        battery.refresh()
        overlap.enforce(
            preset: activePreset,
            windows: registry.windows,
            displays: registry.displays,
            now: now
        )
        order.note(keys: orderingKeys)
        bar?.syncVisibility()
        geometry.observe(pids: observedPids) { [weak self] in
            self?.scheduleRefresh()
        }
    }

    package func stopObserving() {
        coalesced.cancel()
        geometry.stop()
        changes.stopObserving()
    }

    private var observedPids: [pid_t] {
        Array(Set(registry.windows.map(\.ownerPid)))
    }

    private var orderingKeys: [String] {
        let windowKeys = registry.taskbarEntries.map { window -> String in
            TaskbarOrdering.orderingKey(
                bundleIdentifier: registry.bundleIdentifiers[window.ownerPid],
                entryId: WindowEntryIdentifier.text(for: window.identity)
            )
        }
        let launcherKeys = pins.apps.map { TaskbarOrdering.applicationKey($0.bundleIdentifier) }
        let entryIds = ShowDesktopPlan.keys(of: registry.taskbarEntries)

        return OrderedKeys.deduped(launcherKeys + windowKeys + entryIds)
    }

    package func toggleShowDesktop() {
        if showDesktop.toggle() {
            desktop.setSystemShowingDesktop(!desktop.isShowingDesktop)
            return
        }
        if desktop.isShowingDesktop {
            restoreFromDesktop()
        } else {
            hideToDesktop()
        }
        refreshAndEnforce()
    }

    private func hideToDesktop() {
        let visible = ShowDesktopPlan.toHide(among: registry.taskbarEntries)
        for window in visible {
            _ = control.perform(.minimize, on: window)
        }
        desktop.remember(keys: ShowDesktopPlan.keys(of: visible))
    }

    private func restoreFromDesktop() {
        let wanted = ShowDesktopPlan.toRestore(
            among: registry.windows,
            hiddenKeys: desktop.hiddenKeys
        )
        for window in wanted {
            _ = control.perform(.restore, on: window)
        }
        desktop.clear()
    }

    package func reorder(draggedKey: String, onto target: TaskbarEntryModel) {
        order.move(key: draggedKey, onto: target.orderingKey)
        persistPinnedOrder()
    }

    private func persistPinnedOrder() {
        guard let ordered = PinnedOrder.reordered(pins.apps, byKeys: order.keys) else { return }

        Task { await pins.reorder(ordered) }
    }

    package func toggle(entryId: String) {
        guard let window = registry.window(withEntryId: entryId) else { return }
        let action = WindowToggleDecider.action(
            for: window,
            frontmostPid: registry.frontmostPid,
            among: registry.windows
        )
        _ = control.perform(action, on: window)
        refreshAndEnforce()
    }

    package init() {
        registry = WindowRegistry(
            coreGraphicsSource: CoreGraphicsWindowSource(),
            accessibilitySource: AccessibilityWindowSource(),
            applicationsSource: WorkspaceApplicationsSource(),
            displaySource: ScreenGeometrySource(),
            authorization: AccessibilityAuthorization()
        )
        store = PreferencesStore.opened()
        pins = PinnedAppState(store: store)
    }

    package func loadPreferences() async {
        await pins.load()
        order.seed(keys: pins.apps.map { TaskbarOrdering.applicationKey($0.bundleIdentifier) })
        refreshAndEnforce()
    }

    package func activate(entry: TaskbarEntryModel, onDisplay displayId: Int) {
        guard entry.isLauncher else {
            toggle(entryId: entry.id)
            return
        }
        guard let bundleIdentifier = entry.bundleIdentifier else { return }

        if openNewWindowElsewhere(bundleIdentifier: bundleIdentifier, displayId: displayId) {
            return
        }
        launcher.launch(bundleIdentifier: bundleIdentifier)
    }

    package func openNewInstance(entry: TaskbarEntryModel, onDisplay displayId: Int) {
        guard let bundleIdentifier = entry.bundleIdentifier else { return }
        guard let pid = registry.bundleIdentifiers.first(where: { $0.value == bundleIdentifier })?.key,
              let display = registry.displays.first(where: { $0.id == displayId }),
              newWindow.supportsNewWindow(pid: pid)
        else {
            launcher.launch(bundleIdentifier: bundleIdentifier)
            return
        }
        _ = newWindow.openNewWindow(pid: pid, placingOn: display.frame)
        scheduleRefresh()
    }

    private func openNewWindowElsewhere(bundleIdentifier: String, displayId: Int) -> Bool {
        let pids = registry.bundleIdentifiers
            .filter { $0.value == bundleIdentifier }
            .map(\.key)
        guard let pid = pids.first,
              let display = registry.displays.first(where: { $0.id == displayId }),
              newWindow.supportsNewWindow(pid: pid)
        else {
            return false
        }
        guard !NewWindowPlacement.hasWindow(
            pid: pid,
            onDisplay: displayId,
            among: registry.taskbarEntries,
            displays: registry.displays
        ) else {
            return false
        }

        let opened = newWindow.openNewWindow(pid: pid, placingOn: display.frame)
        if opened {
            scheduleRefresh()
        }
        return opened
    }

    package func openBatteryPanel() {
        guard !batteryPanel.isPresented else {
            batteryPanel.dismiss()
            return
        }
        let anchor = NSEvent.mouseLocation

        Task {
            await battery.sampleEnergy()
            batteryPanel.present(anchor: anchor) { [battery] presentation, arrowX in
                BatteryPanelPresentation.content(
                    state: battery.state,
                    energyUsers: battery.energyUsers,
                    presentation: presentation,
                    arrowX: arrowX
                )
            }
        }
    }

    package func openControlCentre() {
        guard !controlCentrePanel.isPresented else {
            controlCentrePanel.dismiss()
            return
        }
        wifi.refresh()
        bluetooth.refresh()
        sound.refresh()
        brightness.refresh()
        controlCentrePanel.present(anchor: NSEvent.mouseLocation) {
            [wifi, bluetooth, sound, brightness] presentation, _ in
            ControlCentrePresentation.content(
                wifi: wifi,
                bluetooth: bluetooth,
                sound: sound,
                brightness: brightness,
                presentation: presentation,
                onOpenSettings: { NSWorkspace.shared.open(BarSettingsLinks.wifi) }
            )
        }
    }

    package func togglePin(entry: TaskbarEntryModel) {
        guard let bundleIdentifier = entry.bundleIdentifier else { return }
        let name = entry.applicationName.isEmpty ? bundleIdentifier : entry.applicationName

        Task {
            if entry.isPinned {
                await pins.unpin(bundleIdentifier: bundleIdentifier)
            } else {
                await pins.pin(bundleIdentifier: bundleIdentifier, displayName: name)
            }
        }
    }

    package func startBar(preset: BarPreset) {
        activePreset = preset
        let host = BarPanelHost(
            registry: registry,
            battery: battery,
            pins: pins,
            order: order,
            desktop: desktop,
            icons: icons,
            displaySource: displays,
            onActivate: { [weak self] entry, displayId in
                self?.activate(entry: entry, onDisplay: displayId)
            },
            onRequestAccessibility: { [authorization] in authorization.requestTrust() },
            onOpenStart: {},
            onTogglePin: { [weak self] entry in self?.togglePin(entry: entry) },
            onDropPin: { [weak self] dropped, target in
                self?.reorder(draggedKey: dropped, onto: target)
            },
            onToggleDesktop: { [weak self] in self?.toggleShowDesktop() },
            onMiddleClick: { [weak self] entry, displayId in
                self?.openNewInstance(entry: entry, onDisplay: displayId)
            },
            onOpenBattery: { [weak self] in self?.openBatteryPanel() },
            onOpenNotifications: {},
            onOpenControlCentre: { [weak self] in self?.openControlCentre() }
        )
        host.present(preset: preset)
        bar = host
    }

    private let store: any PinnedAppStorePort
}
