import SwiftUI

/** The About window's content. */
package struct AboutView: View {
    private let version: AppVersion
    private let icon: Image

    package init(version: AppVersion, icon: Image) {
        self.version = version
        self.icon = icon
    }

    package var body: some View {
        VStack(spacing: AboutMetrics.stackSpacing) {
            icon
                .resizable()
                .frame(width: AboutMetrics.iconSide, height: AboutMetrics.iconSide)

            VStack(spacing: AboutMetrics.identitySpacing) {
                Text(LocalizedStringKey.catalogue("about", "name"))
                    .font(AboutMetrics.appName)

                Text(LocalizedStringKey.catalogue("about", "tagline"))
                    .font(AboutMetrics.tagline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            if version.isPrerelease {
                AboutPrereleaseBadge()
            }

            VStack(spacing: AboutMetrics.identitySpacing) {
                Text(version.short)
                    .font(AboutMetrics.version)
                    .foregroundStyle(.secondary)

                Text(version.commit)
                    .font(AboutMetrics.commit)
                    .foregroundStyle(.tertiary)
                    .textSelection(.enabled)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(AboutMetrics.contentPadding)
    }
}
