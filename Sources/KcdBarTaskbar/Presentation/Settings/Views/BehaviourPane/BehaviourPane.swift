import SwiftUI

package struct BehaviourPane: View {
    package let settings: BarSettingsState
    package let loginItem: LoginItemState
    package let stageManager: StageManagerState
    package let exclusions: QuitExclusionState
    package let runningApplications: [RunningApplication]
    package let isTrackingAvailable: Bool

    package init(
        settings: BarSettingsState,
        loginItem: LoginItemState,
        stageManager: StageManagerState,
        exclusions: QuitExclusionState,
        runningApplications: [RunningApplication],
        isTrackingAvailable: Bool
    ) {
        self.settings = settings
        self.loginItem = loginItem
        self.stageManager = stageManager
        self.exclusions = exclusions
        self.runningApplications = runningApplications
        self.isTrackingAvailable = isTrackingAvailable
    }

    package var body: some View {
        Form {
            Section("settings.behaviour.windows") {
                SettingsEnumPicker(
                    title: "settings.behaviour.grouping",
                    keyPrefix: "bar.grouping",
                    selection: settings.binding(\.grouping)
                )
                SettingsEnumPicker(
                    title: "settings.behaviour.windowScope",
                    keyPrefix: "bar.windowScope",
                    selection: settings.binding(\.windowScope)
                )
                SettingsEnumPicker(
                    title: "settings.behaviour.overlap",
                    keyPrefix: "bar.overlap",
                    selection: settings.binding(\.overlap)
                )
                Toggle("settings.behaviour.soloWindows", isOn: soloWindows)
            }

            Section("settings.behaviour.quitting") {
                Toggle("settings.behaviour.quitsOnLastWindow", isOn: settings.binding(\.quitsOnLastWindow))
                QuitExclusionEditor(exclusions: exclusions, candidates: runningApplications)
            }

            Section("settings.behaviour.displays") {
                SettingsEnumPicker(
                    title: "settings.behaviour.displayPolicy",
                    keyPrefix: "bar.displays",
                    selection: settings.binding(\.displays)
                )
                SettingsEnumPicker(
                    title: "settings.behaviour.autoHide",
                    keyPrefix: "bar.autoHide",
                    selection: settings.binding(\.autoHide)
                )
            }

            Section("settings.behaviour.contents") {
                Toggle("settings.behaviour.trash", isOn: settings.binding(\.showsTrash))
                Toggle("settings.behaviour.battery", isOn: settings.binding(\.showsBattery))
                Toggle("settings.behaviour.controlCentre", isOn: settings.binding(\.showsControlCentre))
                Toggle("settings.behaviour.clock", isOn: settings.binding(\.showsClock))
                if isTrackingAvailable {
                    Toggle("settings.behaviour.tracking", isOn: settings.binding(\.showsTracking))
                }
                Toggle("settings.behaviour.desktopButton", isOn: settings.binding(\.showsDesktopButton))
            }

            Section("settings.behaviour.system") {
                Toggle("settings.behaviour.launchAtLogin", isOn: launchAtLogin)
                Toggle("settings.behaviour.stageManager", isOn: stageManagerEnabled)
            }
        }
        .formStyle(.grouped)
        .onAppear {
            loginItem.refresh()
            stageManager.refresh()
        }
        .task { await exclusions.load() }
    }

    private var stageManagerEnabled: Binding<Bool> {
        Binding(get: { stageManager.isEnabled }, set: { _ in stageManager.toggle() })
    }

    private var launchAtLogin: Binding<Bool> {
        Binding(get: { loginItem.isEnabled }, set: { _ in loginItem.toggle() })
    }

    private var soloWindows: Binding<Bool> {
        Binding(
            get: { SoloWindowPreference.isEnabled },
            set: { SoloWindowPreference.set($0) }
        )
    }
}
