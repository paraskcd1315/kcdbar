import KcdBarDesignSystem
import SwiftUI

package struct StartMenuAppSection: View {
    package let section: ApplicationSection
    package let pinnedIdentifiers: Set<String>
    package let icons: any ApplicationIconPort
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void

    package var body: some View {
        VStack(alignment: .leading, spacing: StartMenuMetrics.rowSpacing) {
            Text(section.key)
                .font(KbTypography.panelDetail)
                .foregroundStyle(KbColors.onSurfaceMuted)
                .padding(.horizontal, KbSpacing.s6)
                .padding(.top, KbSpacing.s3)
            ForEach(section.applications) { application in
                StartMenuAppRow(
                    application: application,
                    icon: icons.icon(forBundleIdentifier: application.bundleIdentifier),
                    isPinned: pinnedIdentifiers.contains(application.bundleIdentifier),
                    onLaunch: { onLaunch(application.bundleIdentifier) },
                    onTogglePin: { onTogglePin(application.bundleIdentifier) }
                )
            }
        }
    }
}
