package struct SoundState: Equatable {
    package let isAvailable: Bool
    package let volume: Double
    package let isMuted: Bool

    package static let unavailable = SoundState(isAvailable: false, volume: 0, isMuted: false)
}
