package enum TaskbarStatusVisibility {
    package static func showsAnything(
        preset: BarPreset,
        hasBattery: Bool,
        hasTracking: Bool
    ) -> Bool {
        (preset.showsBattery && hasBattery)
            || preset.showsControlCentre
            || preset.showsClock
            || (preset.showsTracking && hasTracking)
    }
}
