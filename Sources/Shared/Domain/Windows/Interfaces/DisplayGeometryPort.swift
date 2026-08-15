@MainActor
protocol DisplayGeometryPort {
    func currentDisplays() -> [DisplayGeometry]
}
