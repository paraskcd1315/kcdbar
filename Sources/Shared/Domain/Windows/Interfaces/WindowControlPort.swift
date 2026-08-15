@MainActor
protocol WindowControlPort {
    func perform(_ action: WindowToggleAction, on window: ManagedWindow) -> Bool
    func close(_ window: ManagedWindow) -> Bool
}
