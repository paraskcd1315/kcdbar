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

package struct StartMenuSurface: View {
    package let catalogue: ApplicationCatalogueState
    package let usage: ApplicationUsageState
    package let pinned: PinnedAppState
    package let groups: StartGroupState
    package let editor: any PanelTextEditingPort
    package let icons: any ApplicationIconPort
    package let userName: String
    package let avatar: Image?
    package let arrowX: CGFloat
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void
    package let onPower: (StartPowerAction) -> Void
    package let onSearch: () -> Void

    @Environment(\.popoverRoom) private var room

    private var hasPinned: Bool { !pinned.apps.isEmpty }

    private var bodyHeight: CGFloat { catalogue.bodyHeight(room: room) }

    private var width: CGFloat {
        hasPinned ? StartMenuMetrics.panelWidth : StartMenuMetrics.sidebarWidth
    }

    package var body: some View {
        HStack(alignment: .top, spacing: 0) {
            StartMenuBody(
                catalogue: catalogue,
                usage: usage,
                icons: icons,
                pinnedIdentifiers: Set(pinned.apps.map(\.bundleIdentifier)),
                userName: userName,
                avatar: avatar,
                height: bodyHeight,
                onLaunch: onLaunch,
                onTogglePin: onTogglePin,
                onPower: onPower,
                onSearch: onSearch
            )
            StartMenuPinnedSlot(isShown: hasPinned) {
                StartMenuPinnedPane(
                bands: groups.bands(of: pinned.apps),
                icons: icons,
                editing: groups.editing,
                height: bodyHeight,
                onLaunch: onLaunch,
                onTogglePin: onTogglePin,
                onRename: {
                    editor.beginEditing()
                    groups.beginEditing($0)
                },
                onCommit: { id, title in
                    editor.endEditing()
                    Task { await groups.rename(id, to: title) }
                },
                onRemove: { id in
                    let members = groups.bands(of: pinned.apps)
                        .first { $0.group.id == id }?
                        .applications ?? []
                    Task {
                        for member in members {
                            await pinned.unpin(bundleIdentifier: member.bundleIdentifier)
                        }
                        await groups.remove(id)
                    }
                },
                onToggle: { id in
                    Task { await groups.toggleCollapse(id) }
                },
                onAdd: {
                    editor.beginEditing()
                    Task { await groups.create() }
                },
                onCancel: {
                    editor.endEditing()
                    Task { await groups.cancelEditing() }
                },
                canRemove: groups.editing != nil && !groups.isEditingNew,
                onMove: { moved, group, target in
                    Task {
                        await groups.move(
                            moved,
                            to: group,
                            before: target,
                            among: groups.bands(of: pinned.apps)
                        )
                    }
                }
                )
            }
        }
        .frame(width: width, alignment: .leading)
        .clipShape(KbPopoverShape(arrowX: arrowX))
        .glassEffect(.regular.interactive(), in: KbPopoverShape(arrowX: arrowX))
        .overlay { KbPopoverEdge(arrowX: arrowX) }
        .task {
            await catalogue.load()
            await groups.load()
        }
        .task(id: pinned.apps.map(\.bundleIdentifier)) {
            await groups.seed(pins: pinned.apps)
        }
    }
}
