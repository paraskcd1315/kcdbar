@MainActor
protocol ApplicationLaunchPort {
    func launch(bundleIdentifier: String)
}
