/** One Dock preference KCDBar sets; a nil value removes the key, so the user's own default returns. */
package struct DockDefault: Equatable, Sendable {
    package let key: String
    package let value: DockDefaultValue?

    package init(key: String, value: DockDefaultValue?) {
        self.key = key
        self.value = value
    }
}
