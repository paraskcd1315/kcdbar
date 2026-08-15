import SwiftUI

struct TaskbarNoticeView: View {
    let notice: TaskbarNotice
    let onAct: () -> Void

    var body: some View {
        HStack(spacing: KbSpacing.s3) {
            Image(systemName: notice.symbolName)
                .foregroundStyle(KbColors.onSurfaceMuted)
            Text(LocalizedStringKey(notice.messageKey))
                .font(KbTypography.entryTitle)
                .foregroundStyle(KbColors.onSurfaceMuted)
                .lineLimit(1)
            if notice.isActionable {
                Button(action: onAct) {
                    Text(LocalizedStringKey(notice.actionKey))
                        .font(KbTypography.entryTitleActive)
                }
                .buttonStyle(.plain)
                .foregroundStyle(KbColors.brand)
            }
        }
        .padding(.horizontal, KbSpacing.s4)
    }
}
