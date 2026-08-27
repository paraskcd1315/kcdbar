package struct LastWindowQuitDecision: Equatable, Sendable {
    package let application: RunningApplication
    package let verdict: LastWindowQuitVerdict

    package init(application: RunningApplication, verdict: LastWindowQuitVerdict) {
        self.application = application
        self.verdict = verdict
    }
}
