import CoreGraphics
import Foundation

@MainActor
final class WindowOverlapEnforcer {
    private let control: any WindowControlPort
    private var lastCorrection: [String: Date] = [:]

    init(control: any WindowControlPort) {
        self.control = control
    }

    func enforce(preset: BarPreset, windows: [ManagedWindow], displays: [DisplayGeometry], now: Date) {
        guard preset.overlap == .pushDisplayFillingWindows else { return }

        for window in windows {
            guard let displayId = WindowDisplayResolver.displayId(for: window, in: displays),
                  let display = displays.first(where: { $0.id == displayId })
            else {
                continue
            }
            let barFrame = BarFrameCalculator.frame(for: preset, on: display)
            guard let corrected = WindowOverlapPolicy.correctedFrame(
                for: window,
                barFrame: barFrame,
                display: display
            ) else {
                continue
            }
            let key = WindowEntryIdentifier.text(for: window.identity)
            guard shouldCorrect(key: key, now: now) else { continue }
            lastCorrection[key] = now
            _ = control.setFrame(corrected, on: window)
        }
    }

    private func shouldCorrect(key: String, now: Date) -> Bool {
        guard let previous = lastCorrection[key] else { return true }
        return now.timeIntervalSince(previous) >= WindowOverlapMetrics.reapplyInterval
    }
}
