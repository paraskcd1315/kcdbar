package struct BrightnessState: Equatable {
    package let isAvailable: Bool
    package let level: Double

    package static let unavailable = BrightnessState(isAvailable: false, level: 0)
}
