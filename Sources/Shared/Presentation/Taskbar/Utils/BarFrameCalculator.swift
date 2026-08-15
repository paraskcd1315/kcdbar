import CoreGraphics

enum BarFrameCalculator {
    static func frame(for preset: BarPreset, on display: DisplayGeometry) -> CGRect {
        let screen = display.frame
        let thickness = preset.thickness + (preset.widthMode == .island ? TaskbarMetrics.islandOutset * 2 : 0)
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
