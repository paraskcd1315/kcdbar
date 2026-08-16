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
    package let onCancel: () -> Void
    package let canRemove: Bool
    package let onMove: (String, String, String?) -> Void

    @State private var dragged: String?
    @State private var tiles: [String: CGRect] = [:]
    @State private var bandFrames: [String: CGRect] = [:]
    @State private var rehearsal: [StartPinnedBand]?

    package var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView {
            LazyVStack(alignment: .leading, spacing: KbSpacing.s5) {
                ForEach(shown) { band in
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
                        onDragOver: preview(of:at:),
                        onDrop: drop(at:)
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, KbSpacing.s5)
            .contentShape(Rectangle())
            .coordinateSpace(.named(StartMenuMetrics.pinnedDragSpace))
        }
            .safeAreaBar(edge: .top) {
                Color.clear.frame(height: StartMenuMetrics.pinnedBarInset)
            }
            .scrollBounceBehavior(.basedOnSize)
            StartMenuPinnedBar(
                isEditing: editing != nil,
                showsRemove: canRemove,
                onAdd: onAdd,
                onRemove: { if let editing { onRemove(editing) } },
                onCancel: onCancel
            )
                .zIndex(1)
        }
        .frame(width: StartMenuMetrics.pinnedPaneWidth, height: height, alignment: .top)
        .animation(KbMotion.quick, value: dragged)
        .onChange(of: bands) { rehearsal = nil }
    }

    private var shown: [StartPinnedBand] {
        rehearsal ?? bands
    }

    private func preview(of bundleIdentifier: String, at location: CGPoint) {
        guard let group = group(holding: onto(bundleIdentifier, at: location), at: location) else {
            return
        }

        rehearsal = StartPinnedSections.previewing(
            shown,
            moving: bundleIdentifier,
            to: group,
            before: onto(bundleIdentifier, at: location)
        )
    }

    private func onto(_ carried: String, at location: CGPoint) -> String? {
        tiles.first { $0.key != carried && $0.value.contains(location) }?.key
    }

    private func drop(at location: CGPoint) {
        guard let carried = dragged else { return }
        dragged = nil

        let target = onto(carried, at: location)
        guard let group = group(holding: target, at: location) else {
            rehearsal = nil
            return
        }

        onMove(carried, group, target)
    }

    private func group(holding target: String?, at location: CGPoint) -> String? {
        if let target {
            return shown.first { band in
                band.applications.contains { $0.bundleIdentifier == target }
            }?.group.id
        }

        return bandFrames.first { $0.value.contains(location) }?.key
    }
}
