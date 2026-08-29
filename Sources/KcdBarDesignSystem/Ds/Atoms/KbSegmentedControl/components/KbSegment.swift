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

/** One choice in a segmented control — a label, a glyph, or both. */
package struct KbSegment<Value: Hashable>: Identifiable {
    package let value: Value
    package let titleKey: LocalizedStringKey?
    package let glyph: String?

    package init(value: Value, titleKey: LocalizedStringKey? = nil, glyph: String? = nil) {
        self.value = value
        self.titleKey = titleKey
        self.glyph = glyph
    }

    package var id: Value { value }
}
