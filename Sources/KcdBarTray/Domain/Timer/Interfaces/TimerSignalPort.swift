@MainActor
package protocol TimerSignalPort {
    func listen(_ onChange: @escaping @MainActor (TimerReading) -> Void)
    func stop()
}
