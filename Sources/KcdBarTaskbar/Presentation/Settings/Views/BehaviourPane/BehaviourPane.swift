import SwiftUI

package struct BehaviourPane: View {
    package let settings: BarSettingsState
    package let loginItem: LoginItemState

    package init(settings: BarSettingsState, loginItem: LoginItemState) {
        self.settings = settings
        self.loginItem = loginItem
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
                Toggle("settings.behaviour.tracking", isOn: settings.binding(\.showsTracking))
                Toggle("settings.behaviour.desktopButton", isOn: settings.binding(\.showsDesktopButton))
            }

            Section("settings.behaviour.system") {
                Toggle("settings.behaviour.launchAtLogin", isOn: launchAtLogin)
            }
        }
        .formStyle(.grouped)
        .onAppear { loginItem.refresh() }
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
