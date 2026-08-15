enum BarEdge: String, Codable, CaseIterable, Sendable {
    case bottom
    case top
    case leading
    case trailing

    var isVertical: Bool {
        self == .leading || self == .trailing
    }
}
