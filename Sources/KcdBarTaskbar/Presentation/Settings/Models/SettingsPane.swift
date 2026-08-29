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

import SwiftUI

package enum SettingsPane: String, CaseIterable, Identifiable, Sendable {
    case appearance
    case behaviour

    package var id: String { rawValue }

    package var title: LocalizedStringKey { .catalogue("settings", "pane", rawValue) }

    package var detail: LocalizedStringKey { .catalogue("settings", "pane", rawValue, "detail") }

    package var symbol: String {
        switch self {
        case .appearance: "paintbrush"
        case .behaviour: "slider.horizontal.3"
        }
    }
}
