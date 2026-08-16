package enum WindowPresentationPolicy {
    package static func isTaskbarEntry(_ window: ManagedWindow) -> Bool {
        window.source != .coreGraphicsOnly
    }

    package static func taskbarEntries(from windows: [ManagedWindow]) -> [ManagedWindow] {
        windows.filter(isTaskbarEntry)
    }
}
