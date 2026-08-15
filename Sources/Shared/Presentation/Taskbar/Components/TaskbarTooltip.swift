import SwiftUI

struct TaskbarTooltip: View {
    let applicationName: String
    let windowTitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s1) {
            Text(applicationName)
                .font(KbTypography.entryTitleActive)
                .foregroundStyle(KbColors.onSurface)
            if showsWindowTitle {
                Text(windowTitle)
                    .font(KbTypography.entryTitle)
                    .foregroundStyle(KbColors.onSurfaceMuted)
            }
        }
        .lineLimit(1)
        .padding(.horizontal, KbSpacing.s5)
        .padding(.vertical, KbSpacing.s3)
        .frame(maxWidth: TaskbarMetrics.tooltipMaxWidth, alignment: .leading)
        .fixedSize()
        .glassEffect(.regular, in: .rect(cornerRadius: KbRadii.md))
        .allowsHitTesting(false)
    }

    private var showsWindowTitle: Bool {
        !windowTitle.isEmpty && windowTitle != applicationName
    }
}
