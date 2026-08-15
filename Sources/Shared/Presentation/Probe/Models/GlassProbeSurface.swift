enum GlassProbeSurface: String, CaseIterable, Sendable {
    case borderlessPanel
    case ordinaryWindow

    var labelKey: String {
        switch self {
        case .borderlessPanel: "probe.surface.panel"
        case .ordinaryWindow: "probe.surface.window"
        }
    }
}
