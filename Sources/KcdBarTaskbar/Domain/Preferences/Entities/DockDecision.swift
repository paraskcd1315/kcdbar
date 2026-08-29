/** Everything the Dock service must do for one change, decided in one place. */
package struct DockDecision: Equatable, Sendable {
    package let capture: DockSettingsSnapshot?
    package let write: [DockDefault]
    package let restart: Bool
    package let forget: Bool
    package let verdict: DockVerdict

    package init(
        capture: DockSettingsSnapshot?,
        write: [DockDefault],
        restart: Bool,
        forget: Bool,
        verdict: DockVerdict
    ) {
        self.capture = capture
        self.write = write
        self.restart = restart
        self.forget = forget
        self.verdict = verdict
    }

    package static func nothing(_ verdict: DockVerdict) -> DockDecision {
        DockDecision(capture: nil, write: [], restart: false, forget: false, verdict: verdict)
    }
}
