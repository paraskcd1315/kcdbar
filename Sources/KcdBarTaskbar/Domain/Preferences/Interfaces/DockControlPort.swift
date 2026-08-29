/** The Dock's own preferences and its restart, owned by one service. */
package protocol DockControlPort: Sendable {
    func settings() -> DockSettingsSnapshot
    func write(_ defaults: [DockDefault])
    func restart()
}
