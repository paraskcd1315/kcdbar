package struct WindowScanCounts: Equatable, Sendable {
    package let applications: Int
    package let coreGraphicsRecords: Int
    package let manageableCoreGraphicsRecords: Int
    package let accessibilityRecords: Int

    package static let empty = WindowScanCounts(
        applications: 0,
        coreGraphicsRecords: 0,
        manageableCoreGraphicsRecords: 0,
        accessibilityRecords: 0
    )
}
