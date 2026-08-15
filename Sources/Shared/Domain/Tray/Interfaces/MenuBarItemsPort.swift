@MainActor
protocol MenuBarItemsPort {
    func items() -> [MenuBarItem]
    func press(_ item: MenuBarItem) -> Bool
    func menu(for item: MenuBarItem) -> [MenuBarEntry]
    func invoke(_ entry: MenuBarEntry, in item: MenuBarItem)
}
