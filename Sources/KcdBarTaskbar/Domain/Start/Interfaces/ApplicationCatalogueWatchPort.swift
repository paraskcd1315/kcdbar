package protocol ApplicationCatalogueWatchPort: Sendable {
    @MainActor func watch(_ onChange: @escaping @MainActor () -> Void)
    @MainActor func stopWatching()
}
