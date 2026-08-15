struct WindowScanCounts: Equatable, Sendable {
    let applications: Int
    let coreGraphicsRecords: Int
    let manageableCoreGraphicsRecords: Int
    let accessibilityRecords: Int

    static let empty = WindowScanCounts(
        applications: 0,
        coreGraphicsRecords: 0,
        manageableCoreGraphicsRecords: 0,
        accessibilityRecords: 0
    )
}
