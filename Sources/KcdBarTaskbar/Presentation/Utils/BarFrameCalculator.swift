import CoreGraphics

package enum BarFrameCalculator {
    package static func panelFrame(for preset: BarPreset, on display: DisplayGeometry) -> CGRect {
        let bar = frame(for: preset, on: display)
        let allowance = TaskbarPreviewMetrics.panelAllowance

        switch preset.edge {
        case .bottom:
            return CGRect(x: bar.minX, y: bar.minY, width: bar.width, height: bar.height + allowance)
        case .top:
            return CGRect(
                x: bar.minX,
                y: bar.minY - allowance,
                width: bar.width,
                height: bar.height + allowance
            )
        case .leading:
            return CGRect(x: bar.minX, y: bar.minY, width: bar.width + allowance, height: bar.height)
        case .trailing:
            return CGRect(
                x: bar.minX - allowance,
                y: bar.minY,
                width: bar.width + allowance,
                height: bar.height
            )
        }
    }

    package static func frame(for preset: BarPreset, on display: DisplayGeometry) -> CGRect {
        let screen = display.frame
        let thickness = preset.thickness + (preset.attachment == .floating ? TaskbarMetrics.islandOutset * 2 : 0)
        switch preset.edge {
        case .bottom:
            return CGRect(x: screen.minX, y: screen.minY, width: screen.width, height: thickness)
        case .top:
            return CGRect(x: screen.minX, y: screen.maxY - thickness, width: screen.width, height: thickness)
        case .leading:
            return CGRect(x: screen.minX, y: screen.minY, width: thickness, height: screen.height)
        case .trailing:
            return CGRect(x: screen.maxX - thickness, y: screen.minY, width: thickness, height: screen.height)
        }
    }
}
