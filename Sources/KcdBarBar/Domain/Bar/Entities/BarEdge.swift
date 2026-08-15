package enum BarEdge: String, Codable, CaseIterable, Sendable {
    case bottom
    case top
    case leading
    case trailing

    package var isVertical: Bool {
        self == .leading || self == .trailing
    }
}
