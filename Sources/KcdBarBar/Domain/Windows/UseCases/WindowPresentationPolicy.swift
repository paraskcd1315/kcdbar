enum WindowPresentationPolicy {
    static func isTaskbarEntry(_ window: ManagedWindow) -> Bool {
        window.source != .coreGraphicsOnly
    }

    static func taskbarEntries(from windows: [ManagedWindow]) -> [ManagedWindow] {
        windows.filter(isTaskbarEntry)
    }
}
