/** What the bar decided about the Dock, named for the log. */
package enum DockVerdict: String, Equatable, Sendable {
    case suppressed
    case restored
    case unchanged
    case leftAlone
    case tooSoon
}
