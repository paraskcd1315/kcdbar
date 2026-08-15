/** Which windows a Show Desktop hides, and which of them come back. */
enum ShowDesktopPlan {
    static func toHide(among entries: [ManagedWindow]) -> [ManagedWindow] {
        entries.filter { !$0.isMinimized }
    }

    static func toRestore(among windows: [ManagedWindow], hiddenKeys: [String]) -> [ManagedWindow] {
        let wanted = Set(hiddenKeys)

        return windows.filter { wanted.contains(WindowEntryIdentifier.text(for: $0.identity)) }
    }

    static func keys(of windows: [ManagedWindow]) -> [String] {
        windows.map { WindowEntryIdentifier.text(for: $0.identity) }
    }
}
