struct BrightnessState: Equatable {
    let isAvailable: Bool
    let level: Double

    static let unavailable = BrightnessState(isAvailable: false, level: 0)
}
