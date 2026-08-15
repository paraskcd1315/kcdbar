import CoreGraphics

package struct BarPreset: Codable, Equatable, Sendable {
    package var name: String
    package var edge: BarEdge
    package var alignment: BarAlignment
    package var widthMode: BarWidthMode
    package var attachment: BarAttachment
    package var entryContent: BarEntryContent
    package var entrySizing: BarEntrySizing
    package var grouping: BarGrouping
    package var material: BarMaterial
    package var startButton: BarStartButtonPlacement
    package var autoHide: BarAutoHidePolicy
    package var displays: BarDisplayPolicy
    package var windowScope: BarWindowScope
    package var overlap: BarOverlapPolicy
    package var dockHandling: DockHandling
    package var thickness: CGFloat
    package var entrySpacing: CGFloat
    package var contentPadding: CGFloat
    package var cornerRadius: CGFloat
    package var showsStatusArea: Bool
    package var showsDesktopButton: Bool
}
