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

package enum SettingsMetrics {
    package static let windowWidth: CGFloat = 760
    package static let windowHeight: CGFloat = 560
    package static let sidebarMinWidth: CGFloat = 180
    package static let sidebarWidth: CGFloat = 220
    package static let sidebarMaxWidth: CGFloat = 280
    package static let symbolWidth: CGFloat = 24
    package static let sheetWidth: CGFloat = 360
    package static let thickness: ClosedRange<CGFloat> = 28...96
    package static let cornerRadius: ClosedRange<CGFloat> = 0...32
    package static let entryCornerRadius: ClosedRange<CGFloat> = 0...32
    package static let iconSize: ClosedRange<CGFloat> = 16...64
    package static let spacing: ClosedRange<CGFloat> = 0...24
    package static let padding: ClosedRange<CGFloat> = 0...24
}
