import SwiftUI

/** Marks the build as an alpha. */
package struct AboutPrereleaseBadge: View {
    package init() {}

    package var body: some View {
        Text(LocalizedStringKey.catalogue("about", "badge", "alpha"))
            .font(AboutMetrics.badge)
            .foregroundStyle(.white)
            .padding(.horizontal, AboutMetrics.badgePaddingHorizontal)
            .padding(.vertical, AboutMetrics.badgePaddingVertical)
            .background(
                RoundedRectangle(cornerRadius: AboutMetrics.badgeCornerRadius, style: .continuous)
                    .fill(.orange)
            )
    }
}
