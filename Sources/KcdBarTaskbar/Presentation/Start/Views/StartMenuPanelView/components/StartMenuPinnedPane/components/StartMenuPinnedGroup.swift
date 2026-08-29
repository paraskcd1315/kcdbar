// Copyright 2026 Paras Mohandas Khanchandani Chandani
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
    package let onDragOver: (String, CGPoint) -> Void
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
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .clipped()
        .animation(KbMotion.standard, value: band.group.isCollapsed)
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
        .onChanged {
            onPickUp(bundleIdentifier)
            onDragOver(bundleIdentifier, $0.location)
        }
        .onEnded { onDrop($0.location) }
    }
}
