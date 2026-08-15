import KcdBarDesignSystem
import SwiftUI

package struct TaskbarNoticeView: View {
    package let notice: TaskbarNotice
    package let onAct: () -> Void

    package var body: some View {
        HStack(spacing: KbSpacing.s3) {
            Image(systemName: notice.symbolName)
                .foregroundStyle(KbColors.onSurfaceMuted)
            Text(LocalizedStringKey(notice.messageKey))
                .font(KbTypography.entryTitle)
                .foregroundStyle(KbColors.onSurfaceMuted)
                .lineLimit(1)
            Button(action: onAct) {
                Text(LocalizedStringKey(notice.actionKey))
                    .font(KbTypography.entryTitleActive)
            }
            .buttonStyle(.plain)
            .foregroundStyle(KbColors.brand)
            .kbClickable()
        }
        .padding(.horizontal, KbSpacing.s4)
    }
}
