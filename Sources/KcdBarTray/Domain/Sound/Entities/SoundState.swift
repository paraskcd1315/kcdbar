struct SoundState: Equatable {
    let isAvailable: Bool
    let volume: Double
    let isMuted: Bool

    static let unavailable = SoundState(isAvailable: false, volume: 0, isMuted: false)
}
