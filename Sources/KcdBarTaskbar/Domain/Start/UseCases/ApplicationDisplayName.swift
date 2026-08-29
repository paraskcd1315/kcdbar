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

/** The name as the user should read it, without the invisible marks bundles ship inside theirs. */
package enum ApplicationDisplayName {
    package static func cleaned(_ name: String) -> String {
        let visible = String(String.UnicodeScalarView(name.unicodeScalars.filter { !isInvisible($0) }))
        let trimmed = visible.trimmingCharacters(in: .whitespacesAndNewlines)

        return trimmed.isEmpty ? name : trimmed
    }

    private static func isInvisible(_ scalar: Unicode.Scalar) -> Bool {
        switch scalar.properties.generalCategory {
        case .format, .control, .lineSeparator, .paragraphSeparator: true
        default: false
        }
    }
}
