/** The Dock defaults as they were before KCDBar first changed them. */
struct DockSettingsSnapshot: Codable, Equatable, Sendable {
    var autohide: Bool?
    var autohideDelay: Double?
    var autohideTimeModifier: Double?
    var orientation: String?
    var tilesize: Int?
    var largesize: Int?
    var magnification: Bool?
}
