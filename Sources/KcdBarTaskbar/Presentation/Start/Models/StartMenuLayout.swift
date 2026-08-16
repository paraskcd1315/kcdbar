/** Whether the all-applications list is drawn as rows or as tiles. */
package enum StartMenuLayout: String, CaseIterable, Sendable {
    case list
    case grid

    package var glyph: String {
        switch self {
        case .list: StartMenuMetrics.listGlyph
        case .grid: StartMenuMetrics.gridGlyph
        }
    }
}
