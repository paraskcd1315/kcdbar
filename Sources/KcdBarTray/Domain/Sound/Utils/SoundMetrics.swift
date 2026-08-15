enum SoundMetrics {
    static let mutedSymbol = "speaker.slash.fill"
    static let quietSymbol = "speaker.fill"
    static let mediumSymbol = "speaker.wave.2.fill"
    static let loudSymbol = "speaker.wave.3.fill"

    static let quietCeiling = 0.01
    static let mediumCeiling = 0.5

    static func symbol(volume: Double, isMuted: Bool) -> String {
        guard !isMuted else { return mutedSymbol }
        if volume <= quietCeiling { return quietSymbol }
        if volume <= mediumCeiling { return mediumSymbol }

        return loudSymbol
    }
}
