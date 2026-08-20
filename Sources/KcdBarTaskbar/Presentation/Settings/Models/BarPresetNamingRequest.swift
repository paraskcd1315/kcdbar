package struct BarPresetNamingRequest: Identifiable, Equatable, Sendable {
    package let reason: BarPresetNamingReason
    package let proposed: String

    package var id: String { "\(reason.rawValue).\(proposed)" }

    package init(reason: BarPresetNamingReason, proposed: String) {
        self.reason = reason
        self.proposed = proposed
    }
}
