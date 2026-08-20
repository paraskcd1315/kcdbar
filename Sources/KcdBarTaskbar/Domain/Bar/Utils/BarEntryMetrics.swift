import CoreGraphics

package enum BarEntryMetrics {
    package static let iconSize: CGFloat = 34
    package static let minimumIconSize: CGFloat = 12
    package static let iconBodyRatio: CGFloat = 0.81

    package static func iconSize(for preset: BarPreset) -> CGFloat {
        let available = preset.thickness - preset.contentPadding * 2

        return max(minimumIconSize, min(preset.iconSize, available))
    }
}
