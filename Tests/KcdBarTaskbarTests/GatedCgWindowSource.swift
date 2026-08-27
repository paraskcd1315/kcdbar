import CoreGraphics
import Foundation
@testable import KcdBarTaskbar

/** Answers the first read only when released, and every later read at once. */
final class GatedCgWindowSource: CgWindowSourcePort, @unchecked Sendable {
    private let first: [CgWindowRecord]
    private let later: [CgWindowRecord]
    private let gate = DispatchSemaphore(value: 0)
    private let lock = NSLock()
    private var calls = 0
    private var blocked = false

    init(first: [CgWindowRecord], later: [CgWindowRecord]) {
        self.first = first
        self.later = later
    }

    var isBlocked: Bool {
        lock.withLock { blocked }
    }

    func release() {
        gate.signal()
    }

    func currentWindows(flipReference: CGFloat) -> [CgWindowRecord] {
        let call = lock.withLock {
            calls += 1
            return calls
        }
        guard call == 1 else { return later }

        lock.withLock { blocked = true }
        gate.wait()

        return first
    }
}
