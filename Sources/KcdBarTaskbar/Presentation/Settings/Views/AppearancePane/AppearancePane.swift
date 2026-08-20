import SwiftUI

package struct AppearancePane: View {
    package let settings: BarSettingsState

    package init(settings: BarSettingsState) {
        self.settings = settings
    }

    package var body: some View {
        Form {
            Section("settings.appearance.preset") {
                Picker("settings.appearance.preset", selection: presetName) {
                    ForEach(settings.presets, id: \.name) { preset in
                        Text(LocalizedStringKey.catalogue("bar", "preset", preset.name)).tag(preset.name)
                    }
                }
                .labelsHidden()
            }

            Section("settings.appearance.placement") {
                SettingsEnumPicker(
                    title: "settings.appearance.edge",
                    keyPrefix: "bar.edge",
                    selection: settings.binding(\.edge)
                )
                SettingsEnumPicker(
                    title: "settings.appearance.alignment",
                    keyPrefix: "bar.alignment",
                    selection: settings.binding(\.alignment)
                )
                SettingsEnumPicker(
                    title: "settings.appearance.widthMode",
                    keyPrefix: "bar.widthMode",
                    selection: settings.binding(\.widthMode)
                )
                SettingsEnumPicker(
                    title: "settings.appearance.attachment",
                    keyPrefix: "bar.attachment",
                    selection: settings.binding(\.attachment)
                )
                SettingsEnumPicker(
                    title: "settings.appearance.startButton",
                    keyPrefix: "bar.startButton",
                    selection: settings.binding(\.startButton)
                )
            }

            Section("settings.appearance.entries") {
                SettingsEnumPicker(
                    title: "settings.appearance.entryContent",
                    keyPrefix: "bar.entryContent",
                    selection: settings.binding(\.entryContent)
                )
                SettingsEnumPicker(
                    title: "settings.appearance.entrySizing",
                    keyPrefix: "bar.entrySizing",
                    selection: settings.binding(\.entrySizing)
                )
                SettingsSliderRow(
                    title: "settings.appearance.entryCornerRadius",
                    range: SettingsMetrics.entryCornerRadius,
                    value: settings.binding(\.entryCornerRadius)
                )
                SettingsSliderRow(
                    title: "settings.appearance.iconSize",
                    range: SettingsMetrics.iconSize,
                    value: settings.binding(\.iconSize)
                )
            }

            Section("settings.appearance.shape") {
                SettingsEnumPicker(
                    title: "settings.appearance.material",
                    keyPrefix: "bar.material",
                    selection: settings.binding(\.material)
                )
                SettingsSliderRow(
                    title: "settings.appearance.thickness",
                    range: SettingsMetrics.thickness,
                    value: settings.binding(\.thickness)
                )
                SettingsSliderRow(
                    title: "settings.appearance.cornerRadius",
                    range: SettingsMetrics.cornerRadius,
                    value: settings.binding(\.cornerRadius)
                )
                SettingsSliderRow(
                    title: "settings.appearance.entrySpacing",
                    range: SettingsMetrics.spacing,
                    value: settings.binding(\.entrySpacing)
                )
                SettingsSliderRow(
                    title: "settings.appearance.contentPadding",
                    range: SettingsMetrics.padding,
                    value: settings.binding(\.contentPadding)
                )
            }
        }
        .formStyle(.grouped)
    }

    private var presetName: Binding<String> {
        Binding(
            get: { settings.preset.name },
            set: { name in Task { await settings.select(presetNamed: name) } }
        )
    }
}
