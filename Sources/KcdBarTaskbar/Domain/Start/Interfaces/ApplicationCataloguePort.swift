package protocol ApplicationCataloguePort: Sendable {
    func installedApplications() async -> [InstalledApplication]
}
