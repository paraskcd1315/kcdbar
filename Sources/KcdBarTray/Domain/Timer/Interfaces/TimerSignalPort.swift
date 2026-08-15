@MainActor
package protocol TimerSignalPort {
    func listen(_ onChange: @escaping @MainActor @Sendable (TimerReading) -> Void)
    func stop()
}
