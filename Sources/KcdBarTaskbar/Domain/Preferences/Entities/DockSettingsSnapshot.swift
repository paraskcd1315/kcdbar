/** The Dock defaults as they were before KCDBar first changed them. */
package struct DockSettingsSnapshot: Codable, Equatable, Sendable {
    package var autohide: Bool?
    package var autohideDelay: Double?
    package var autohideTimeModifier: Double?
    package var orientation: String?
    package var tilesize: Int?
    package var largesize: Int?
    package var magnification: Bool?
}
