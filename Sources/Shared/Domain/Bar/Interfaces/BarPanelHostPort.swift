@MainActor
protocol BarPanelHostPort: AnyObject {
    func present(preset: BarPreset)
    func syncVisibility()
    func dismiss()
}
