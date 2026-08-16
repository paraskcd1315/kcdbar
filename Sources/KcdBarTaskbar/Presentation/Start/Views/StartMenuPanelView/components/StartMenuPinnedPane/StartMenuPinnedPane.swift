import KcdBarDesignSystem
import SwiftUI

package struct StartMenuPinnedPane: View {
    package let bands: [StartPinnedBand]
    package let icons: any ApplicationIconPort
    package let editing: String?
    package let height: CGFloat
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void
    package let onRename: (String) -> Void
    package let onCommit: (String, String) -> Void
    package let onRemove: (String) -> Void
    package let onToggle: (String) -> Void
    package let onAdd: () -> Void
    package let onMove: (String, String, String?) -> Void

    @State private var dragged: String?
    @State private var tiles: [String: CGRect] = [:]
    @State private var bandFrames: [String: CGRect] = [:]

    package var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: KbSpacing.s5) {
                ForEach(bands) { band in
                    StartMenuPinnedGroup(
                        band: band,
                        icons: icons,
                        isEditing: editing == band.group.id,
                        dragged: dragged,
                        onLaunch: onLaunch,
                        onTogglePin: onTogglePin,
                        onToggle: { onToggle(band.group.id) },
                        onRename: { onRename(band.group.id) },
                        onCommit: { onCommit(band.group.id, $0) },
                        onRemove: { onRemove(band.group.id) },
                        onFrame: { tiles[$0] = $1 },
                        onBandFrame: { bandFrames[band.group.id] = $0 },
                        onPickUp: { dragged = $0 },
                        onDrop: drop(at:)
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, KbSpacing.s5)
            .contentShape(Rectangle())
            .coordinateSpace(.named(StartMenuMetrics.pinnedDragSpace))
        }
        .frame(width: StartMenuMetrics.pinnedPaneWidth, height: height)
        .safeAreaBar(edge: .top) {
            StartMenuPinnedBar(onAdd: onAdd)
        }
        .scrollBounceBehavior(.basedOnSize)
        .animation(KbMotion.quick, value: dragged)
    }

    private func drop(at location: CGPoint) {
        guard let carried = dragged else { return }
        dragged = nil

        let onto = tiles.first { $0.key != carried && $0.value.contains(location) }?.key
        guard let group = group(holding: onto, at: location) else { return }

        onMove(carried, group, onto)
    }

    private func group(holding target: String?, at location: CGPoint) -> String? {
        if let target {
            return bands.first { band in
                band.applications.contains { $0.bundleIdentifier == target }
            }?.group.id
        }

        return bandFrames.first { $0.value.contains(location) }?.key
    }
}
