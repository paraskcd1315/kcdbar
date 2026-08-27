/** What the bar decided about an application whose last window closed, named for the log. */
package enum LastWindowQuitVerdict: String, Equatable, Sendable {
    case quit
    case launching
    case unquittable
    case excluded
    case menuExtra
    case silent
}
