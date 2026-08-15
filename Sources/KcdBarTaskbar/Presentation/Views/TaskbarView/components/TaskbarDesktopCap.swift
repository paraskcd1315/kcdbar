import SwiftUI

package struct TaskbarDesktopCap: View {
    package let preset: BarPreset
    package let isShowingDesktop: Bool
    package let onToggle: () -> Void

    package var body: some View {
        TaskbarShowDesktopButton(
            isShowingDesktop: isShowingDesktop,
            shape: KbBarShape.trailingCap(
                edge: preset.edge,
                attachment: preset.attachment,
                cornerRadius: preset.cornerRadius
            ),
            onToggle: onToggle
        )
    }
}
