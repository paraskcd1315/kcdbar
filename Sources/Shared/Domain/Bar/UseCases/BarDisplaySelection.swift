/** Which displays a preset wants a bar on. */
enum BarDisplaySelection {
    static func wanted(for preset: BarPreset, among displays: [DisplayGeometry]) -> [DisplayGeometry] {
        switch preset.displays {
        case .primaryOnly: displays.filter(\.isPrimary)
        case .allDisplays, .chosenDisplays: displays
        }
    }
}
