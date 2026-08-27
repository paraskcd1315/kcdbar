import Foundation
@testable import KcdBarTaskbar

final class RecordingApplicationTerminator: ApplicationTerminationPort, @unchecked Sendable {
    private(set) var quit: [String] = []

    func quit(bundleIdentifier: String) -> Bool {
        quit.append(bundleIdentifier)
        return true
    }
}
