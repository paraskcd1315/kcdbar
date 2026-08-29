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

/** The heading an application sorts under — its first letter, or the digit band. */
package enum ApplicationSectionKey {
    package static func of(_ displayName: String) -> String {
        guard let first = ApplicationSortKey.of(displayName).first else {
            return StartMenuMetrics.otherSectionKey
        }
        let folded = String(first).folding(
            options: [.diacriticInsensitive, .caseInsensitive],
            locale: .current
        )
        guard let letter = folded.first, letter.isLetter else {
            return StartMenuMetrics.otherSectionKey
        }

        return letter.uppercased()
    }
}
