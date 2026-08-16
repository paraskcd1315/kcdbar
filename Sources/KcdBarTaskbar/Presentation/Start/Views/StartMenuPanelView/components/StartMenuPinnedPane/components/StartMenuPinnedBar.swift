import KcdBarDesignSystem
import SwiftUI

package struct StartMenuPinnedBar: View {
    package let isEditing: Bool
    package let onAdd: () -> Void
    package let onRemove: () -> Void
    package let onCancel: () -> Void

    package var body: some View {
        HStack(spacing: KbSpacing.s3) {
            Spacer(minLength: 0)
            if isEditing {
                StartMenuHeaderButton(
                    glyph: StartMenuMetrics.trashGlyph,
                    titleKey: "start.group.remove",
                    isDestructive: true,
                    action: onRemove
                )
                StartMenuHeaderButton(
                    glyph: StartMenuMetrics.cancelGlyph,
                    titleKey: "start.group.cancel",
                    action: onCancel
                )
            } else {
                StartMenuHeaderButton(
                    glyph: StartMenuMetrics.addGlyph,
                    titleKey: "start.group.add",
                    action: onAdd
                )
            }
        }
        .padding(.horizontal, KbSpacing.s5)
        .padding(.vertical, KbSpacing.s4)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .animation(KbMotion.quick, value: isEditing)
    }
}
