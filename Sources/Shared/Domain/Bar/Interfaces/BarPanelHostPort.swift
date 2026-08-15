@MainActor
protocol BarPanelHostPort: AnyObject {
    func present(preset: BarPreset)
    func dismiss()
}
