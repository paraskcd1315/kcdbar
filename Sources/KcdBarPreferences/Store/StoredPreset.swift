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

import Foundation
import SwiftData
import KcdBarTaskbar

/** One saved bar preset, held as its encoded form so a new axis needs no schema change. */
@Model
package final class StoredPreset {
    @Attribute(.unique) package var name: String
    package var payload: Data
    package var isBuiltIn: Bool

    package init(name: String, payload: Data, isBuiltIn: Bool) {
        self.name = name
        self.payload = payload
        self.isBuiltIn = isBuiltIn
    }
}
