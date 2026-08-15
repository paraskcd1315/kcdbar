/** Which displays a preset wants a bar on. */
package enum BarDisplaySelection {
    package static func wanted(for preset: BarPreset, among displays: [DisplayGeometry]) -> [DisplayGeometry] {
        switch preset.displays {
        case .primaryOnly: displays.filter(\.isPrimary)
        case .allDisplays, .chosenDisplays: displays
        }
    }
}
