@MainActor
protocol SoundPort {
    func state() -> SoundState
    func setVolume(_ volume: Double)
    func setMuted(_ isMuted: Bool)
}
