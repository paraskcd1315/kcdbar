package enum SoundMetrics {
    package static let mutedSymbol = "speaker.slash.fill"
    package static let quietSymbol = "speaker.fill"
    package static let mediumSymbol = "speaker.wave.2.fill"
    package static let loudSymbol = "speaker.wave.3.fill"

    package static let quietCeiling = 0.01
    package static let mediumCeiling = 0.5

    package static func symbol(volume: Double, isMuted: Bool) -> String {
        guard !isMuted else { return mutedSymbol }
        if volume <= quietCeiling { return quietSymbol }
        if volume <= mediumCeiling { return mediumSymbol }

        return loudSymbol
    }
}
