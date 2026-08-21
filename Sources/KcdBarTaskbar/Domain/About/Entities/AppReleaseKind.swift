/** What a version number says this release is. */
package enum AppReleaseKind: String, Sendable, CaseIterable {
    case milestone
    case feature
    case fix
}
