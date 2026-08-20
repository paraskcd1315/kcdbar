package struct BarRefreshReading: Equatable, Sendable {
    package let windows: Int
    package let applications: Int
    package let trusted: Bool
    package let preset: String
    package let battery: Bool

    package init(windows: Int, applications: Int, trusted: Bool, preset: String, battery: Bool) {
        self.windows = windows
        self.applications = applications
        self.trusted = trusted
        self.preset = preset
        self.battery = battery
    }
}
