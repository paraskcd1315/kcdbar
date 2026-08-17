/** What a category folder shows on its face — its first apps, with the remainder sharing one cell. */
package enum ApplicationFolderPreview {
    package static func cells(of applications: [InstalledApplication]) -> [[InstalledApplication]] {
        let slots = StartMenuMetrics.folderPreviewCount
        guard applications.count > slots else { return applications.map { [$0] } }

        let leading = applications.prefix(slots - 1).map { [$0] }

        return leading + [Array(applications.dropFirst(slots - 1))]
    }
}
