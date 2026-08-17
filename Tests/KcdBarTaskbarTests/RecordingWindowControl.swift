import CoreGraphics

@testable import KcdBarTaskbar

@MainActor
final class RecordingWindowControl: WindowControlPort {
    private(set) var performed: [(WindowToggleAction, WindowIdentity)] = []
    private(set) var closed: [WindowIdentity] = []
    private(set) var framed: [(CGRect, WindowIdentity)] = []

    func perform(_ action: WindowToggleAction, on window: ManagedWindow) -> Bool {
        performed.append((action, window.identity))

        return true
    }

    func close(_ window: ManagedWindow) -> Bool {
        closed.append(window.identity)

        return true
    }

    func setFrame(_ frame: CGRect, on window: ManagedWindow) -> Bool {
        framed.append((frame, window.identity))

        return true
    }
}
