import KcdBarDesignSystem
import SwiftUI

package struct StartMenuLetterRecents: View {
    package let applications: [InstalledApplication]
    package let icons: any ApplicationIconPort
    package let onLaunch: (String) -> Void

    package var body: some View {
        ZStack {
            if !applications.isEmpty {
                VStack(alignment: .leading, spacing: KbSpacing.s3) {
                    HStack(spacing: KbSpacing.s2) {
                        Image(systemName: StartMenuMetrics.recentGlyph)
                            .font(.system(size: StartMenuMetrics.disclosureSize, weight: .semibold))
                        StartMenuSectionHeading(title: "start.recent")
                    }
                    .foregroundStyle(KbColors.onSurfaceMuted)
                    LazyVGrid(columns: columns, spacing: KbSpacing.s3) {
                        ForEach(applications) { application in
                            StartMenuAppIcon(
                                icon: icons.icon(forBundleIdentifier: application.bundleIdentifier),
                                size: StartMenuMetrics.recentIconSize
                            )
                            .kbTappable(in: Rectangle()) { onLaunch(application.bundleIdentifier) }
                        }
                    }
                }
            }
        }
    }

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: KbSpacing.s3),
            count: StartMenuMetrics.letterGridColumns
        )
    }
}
