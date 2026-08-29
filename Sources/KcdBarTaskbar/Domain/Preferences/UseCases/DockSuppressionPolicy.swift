import Foundation

/** The single writer of the Dock invariant, so no call site can restart it twice. */
package enum DockSuppressionPolicy {
    package static func decide(
        handling: DockHandling,
        captured: DockSettingsSnapshot?,
        lastRestart: Date?,
        now: Date,
        current: () -> DockSettingsSnapshot
    ) -> DockDecision {
        switch handling {
        case .hide:
            guard captured == nil else { return .nothing(.unchanged) }
            guard allowsRestart(lastRestart, now: now) else { return .nothing(.tooSoon) }
            return DockDecision(
                capture: current(),
                write: suppression,
                restart: true,
                forget: false,
                verdict: .suppressed
            )
        case .borrowReservation, .leaveAlone:
            guard let captured else { return .nothing(.leftAlone) }
            guard allowsRestart(lastRestart, now: now) else { return .nothing(.tooSoon) }
            return DockDecision(
                capture: nil,
                write: restoring(captured),
                restart: true,
                forget: true,
                verdict: .restored
            )
        }
    }

    package static var suppression: [DockDefault] {
        [
            DockDefault(
                key: DockControlKeys.autohide,
                value: .flag(DockSuppressionValues.autohide)),
            DockDefault(
                key: DockControlKeys.autohideDelay,
                value: .number(DockSuppressionValues.autohideDelay)),
            DockDefault(
                key: DockControlKeys.autohideTimeModifier,
                value: .number(DockSuppressionValues.autohideTimeModifier)),
            DockDefault(
                key: DockControlKeys.minimizeEffect,
                value: .text(DockSuppressionValues.minimizeEffect)),
        ]
    }

    package static func restoring(_ snapshot: DockSettingsSnapshot) -> [DockDefault] {
        [
            DockDefault(
                key: DockControlKeys.autohide,
                value: snapshot.autohide.map(DockDefaultValue.flag)),
            DockDefault(
                key: DockControlKeys.autohideDelay,
                value: snapshot.autohideDelay.map(DockDefaultValue.number)),
            DockDefault(
                key: DockControlKeys.autohideTimeModifier,
                value: snapshot.autohideTimeModifier.map(DockDefaultValue.number)),
            DockDefault(
                key: DockControlKeys.minimizeEffect,
                value: snapshot.minimizeEffect.map(DockDefaultValue.text)),
        ]
    }

    private static func allowsRestart(_ lastRestart: Date?, now: Date) -> Bool {
        guard let lastRestart else { return true }
        return now.timeIntervalSince(lastRestart) >= DockMetrics.restartFloor
    }
}
