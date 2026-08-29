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

import CoreGraphics

package struct BarPreset: Codable, Equatable, Sendable {
    package var name: String
    package var edge: BarEdge
    package var alignment: BarAlignment
    package var widthMode: BarWidthMode
    package var attachment: BarAttachment
    package var entryContent: BarEntryContent
    package var entrySizing: BarEntrySizing
    package var entryFit: BarEntryFit
    package var grouping: BarGrouping
    package var material: BarMaterial
    package var startButton: BarStartButtonPlacement
    package var startMark: BarStartMark
    package var autoHide: BarAutoHidePolicy
    package var displays: BarDisplayPolicy
    package var windowScope: BarWindowScope
    package var overlap: BarOverlapPolicy
    package var dockHandling: DockHandling
    package var thickness: CGFloat
    package var entrySpacing: CGFloat
    package var contentPadding: CGFloat
    package var cornerRadius: CGFloat
    package var entryCornerRadius: CGFloat
    package var iconSize: CGFloat
    package var showsTrash: Bool
    package var showsBattery: Bool
    package var showsControlCentre: Bool
    package var showsClock: Bool
    package var showsTracking: Bool
    package var showsDesktopButton: Bool
    package var quitsOnLastWindow: Bool
}

extension BarPreset {
    private enum RetiredKeys: String, CodingKey {
        case showsStatusArea
    }

    package init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let retired = try decoder.container(keyedBy: RetiredKeys.self)
        let fallback = BarPresetCatalogue.default

        name = try container.decode(String.self, forKey: .name)
        edge = try container.decodeIfPresent(BarEdge.self, forKey: .edge) ?? fallback.edge
        alignment = try container.decodeIfPresent(BarAlignment.self, forKey: .alignment) ?? fallback.alignment
        widthMode = try container.decodeIfPresent(BarWidthMode.self, forKey: .widthMode) ?? fallback.widthMode
        attachment = try container.decodeIfPresent(BarAttachment.self, forKey: .attachment) ?? fallback.attachment
        entryContent = try container.decodeIfPresent(BarEntryContent.self, forKey: .entryContent)
            ?? fallback.entryContent
        entrySizing = try container.decodeIfPresent(BarEntrySizing.self, forKey: .entrySizing) ?? fallback.entrySizing
        entryFit = try container.decodeIfPresent(BarEntryFit.self, forKey: .entryFit) ?? fallback.entryFit
        grouping = try container.decodeIfPresent(BarGrouping.self, forKey: .grouping) ?? fallback.grouping
        material = try container.decodeIfPresent(BarMaterial.self, forKey: .material) ?? fallback.material
        startButton = try container.decodeIfPresent(BarStartButtonPlacement.self, forKey: .startButton)
            ?? fallback.startButton
        startMark = try container.decodeIfPresent(BarStartMark.self, forKey: .startMark) ?? fallback.startMark
        autoHide = try container.decodeIfPresent(BarAutoHidePolicy.self, forKey: .autoHide) ?? fallback.autoHide
        displays = try container.decodeIfPresent(BarDisplayPolicy.self, forKey: .displays) ?? fallback.displays
        windowScope = try container.decodeIfPresent(BarWindowScope.self, forKey: .windowScope) ?? fallback.windowScope
        overlap = try container.decodeIfPresent(BarOverlapPolicy.self, forKey: .overlap) ?? fallback.overlap
        dockHandling = try container.decodeIfPresent(DockHandling.self, forKey: .dockHandling) ?? fallback.dockHandling
        thickness = try container.decodeIfPresent(CGFloat.self, forKey: .thickness) ?? fallback.thickness
        entrySpacing = try container.decodeIfPresent(CGFloat.self, forKey: .entrySpacing) ?? fallback.entrySpacing
        contentPadding = try container.decodeIfPresent(CGFloat.self, forKey: .contentPadding) ?? fallback.contentPadding
        cornerRadius = try container.decodeIfPresent(CGFloat.self, forKey: .cornerRadius) ?? fallback.cornerRadius
        entryCornerRadius = try container.decodeIfPresent(CGFloat.self, forKey: .entryCornerRadius)
            ?? fallback.entryCornerRadius
        iconSize = try container.decodeIfPresent(CGFloat.self, forKey: .iconSize) ?? fallback.iconSize
        let statusArea = try retired.decodeIfPresent(Bool.self, forKey: .showsStatusArea)
        showsTrash = try container.decodeIfPresent(Bool.self, forKey: .showsTrash) ?? fallback.showsTrash
        showsBattery = try container.decodeIfPresent(Bool.self, forKey: .showsBattery)
            ?? statusArea ?? fallback.showsBattery
        showsControlCentre = try container.decodeIfPresent(Bool.self, forKey: .showsControlCentre)
            ?? statusArea ?? fallback.showsControlCentre
        showsClock = try container.decodeIfPresent(Bool.self, forKey: .showsClock) ?? statusArea ?? fallback.showsClock
        showsTracking = try container.decodeIfPresent(Bool.self, forKey: .showsTracking)
            ?? statusArea ?? fallback.showsTracking
        showsDesktopButton = try container.decodeIfPresent(Bool.self, forKey: .showsDesktopButton)
            ?? fallback.showsDesktopButton
        quitsOnLastWindow = try container.decodeIfPresent(Bool.self, forKey: .quitsOnLastWindow)
            ?? fallback.quitsOnLastWindow
    }
}
