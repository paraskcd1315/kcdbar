import SwiftUI

struct TaskbarDesktopCap: View {
    let preset: BarPreset
    let isShowingDesktop: Bool
    let onToggle: () -> Void

    var body: some View {
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
