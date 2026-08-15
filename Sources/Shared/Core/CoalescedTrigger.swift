import Foundation

@MainActor
final class CoalescedTrigger {
    private let interval: TimeInterval
    private let action: () -> Void
    private var timer: Timer?

    init(interval: TimeInterval, action: @escaping () -> Void) {
        self.interval = interval
        self.action = action
    }

    func fire() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            MainActor.assumeIsolated {
                self?.timer = nil
                self?.action()
            }
        }
    }

    func cancel() {
        timer?.invalidate()
        timer = nil
    }
}
