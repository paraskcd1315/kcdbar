protocol BatteryPort: Sendable {
    func state() -> BatteryState
    func energyUsers() async -> [EnergyUser]
}
