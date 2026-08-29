/** Which windows a Show Desktop hides, and which of them come back. */
package enum ShowDesktopPlan {
    package static func toHide(among entries: [ManagedWindow]) -> [ManagedWindow] {
        entries.filter { !$0.isMinimized && WindowSpacePolicy.isOnActiveSpace($0) }
    }

    package static func toRestore(among windows: [ManagedWindow], hiddenKeys: [String]) -> [ManagedWindow] {
        let wanted = Set(hiddenKeys)

        return windows.filter { wanted.contains(WindowEntryIdentifier.text(for: $0.identity)) }
    }

    package static func keys(of windows: [ManagedWindow]) -> [String] {
        windows.map { WindowEntryIdentifier.text(for: $0.identity) }
    }
}
