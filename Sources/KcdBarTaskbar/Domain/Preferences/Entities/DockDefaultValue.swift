/** A value KCDBar writes into the Dock's own preferences. */
package enum DockDefaultValue: Equatable, Sendable {
    case flag(Bool)
    case number(Double)
    case text(String)
}
