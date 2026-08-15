import Foundation

@MainActor
protocol WindowGeometryObserverPort: AnyObject {
    func observe(pids: [pid_t], onChange: @escaping () -> Void)
    func stop()
}
