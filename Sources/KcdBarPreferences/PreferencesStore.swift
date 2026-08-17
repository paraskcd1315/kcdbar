import KcdBarTaskbar

/** Opens the app's SwiftData store, falling back to memory so the bar still runs. */
package enum PreferencesStore {
    package static func opened() -> any PinnedAppStorePort & StartPinStorePort & StartGroupStorePort & ApplicationUsageStorePort & PresetStorePort {
        guard let container = KcdBarStore.opened() else { return EphemeralPinnedAppStore() }

        return KcdBarStore(modelContainer: container)
    }
}
