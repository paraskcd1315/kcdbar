import CoreGraphics

struct BarPreset: Codable, Equatable, Sendable {
    var name: String
    var edge: BarEdge
    var alignment: BarAlignment
    var widthMode: BarWidthMode
    var entryContent: BarEntryContent
    var entrySizing: BarEntrySizing
    var grouping: BarGrouping
    var material: BarMaterial
    var startButton: BarStartButtonPlacement
    var autoHide: BarAutoHidePolicy
    var displays: BarDisplayPolicy
    var windowScope: BarWindowScope
    var overlap: BarOverlapPolicy
    var dockHandling: DockHandling
    var thickness: CGFloat
    var entrySpacing: CGFloat
    var contentPadding: CGFloat
    var cornerRadius: CGFloat
    var showsStatusArea: Bool
}
