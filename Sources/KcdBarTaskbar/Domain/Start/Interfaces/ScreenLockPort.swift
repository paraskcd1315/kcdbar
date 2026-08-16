package protocol ScreenLockPort: Sendable {
    @MainActor
    func lock() -> Bool
}
