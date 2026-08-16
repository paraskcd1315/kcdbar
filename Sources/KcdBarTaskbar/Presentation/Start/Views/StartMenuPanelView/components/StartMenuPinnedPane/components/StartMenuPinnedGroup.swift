import KcdBarDesignSystem
import SwiftUI

package struct StartMenuPinnedGroup: View {
    package let band: StartPinnedBand
    package let icons: any ApplicationIconPort
    package let isEditing: Bool
    package let dragged: String?
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void
    package let onToggle: () -> Void
    package let onRename: () -> Void
    package let onCommit: (String) -> Void
    package let onRemove: () -> Void
    package let onFrame: (String, CGRect) -> Void
    package let onBandFrame: (CGRect) -> Void
    package let onPickUp: (String) -> Void
    package let onDrop: (CGPoint) -> Void

    package var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s3) {
            StartMenuGroupHeading(
                group: band.group,
                isEditing: isEditing,
                onToggle: onToggle,
                onRename: onRename,
                onCommit: onCommit,
                onRemove: onRemove
            )
            if !band.group.isCollapsed {
                LazyVGrid(columns: columns, spacing: KbSpacing.s3) {
                ForEach(band.applications) { application in
                    StartMenuPinnedTile(
                        app: PinnedApp(
                            bundleIdentifier: application.bundleIdentifier,
                            displayName: application.displayName,
                            order: 0
                        ),
                        icon: icons.icon(forBundleIdentifier: application.bundleIdentifier),
                        isDragging: dragged == application.bundleIdentifier,
                        onLaunch: { onLaunch(application.bundleIdentifier) },
                        onUnpin: { onTogglePin(application.bundleIdentifier) }
                    )
                    .onGeometryChange(for: CGRect.self) {
                        $0.frame(in: .named(StartMenuMetrics.pinnedDragSpace))
                    } action: {
                        onFrame(application.bundleIdentifier, $0)
                    }
                    .gesture(drag(for: application.bundleIdentifier))
                    }
                }
                .padding(.horizontal, KbSpacing.s6)
                .frame(minHeight: StartMenuMetrics.emptyBandHeight, alignment: .top)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onGeometryChange(for: CGRect.self) {
            $0.frame(in: .named(StartMenuMetrics.pinnedDragSpace))
        } action: {
            onBandFrame($0)
        }
        .animation(KbMotion.quick, value: band.applications)
    }

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: KbSpacing.s3),
            count: StartMenuMetrics.pinnedColumns
        )
    }

    private func drag(for bundleIdentifier: String) -> some Gesture {
        DragGesture(
            minimumDistance: StartMenuMetrics.dragThreshold,
            coordinateSpace: .named(StartMenuMetrics.pinnedDragSpace)
        )
        .onChanged { _ in onPickUp(bundleIdentifier) }
        .onEnded { onDrop($0.location) }
    }
}
