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

package enum BarPresetNaming {
    package static let copySuffix = "copy"

    package static func copyName(of base: String, taken: Set<String>) -> String {
        let wanted = "\(base) \(copySuffix)"
        guard taken.contains(wanted) else { return wanted }

        var index = 2
        while taken.contains("\(wanted) \(index)") {
            index += 1
        }
        return "\(wanted) \(index)"
    }

    package static func trimmed(_ name: String) -> String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    package static func isAcceptable(_ name: String, taken: Set<String>) -> Bool {
        let candidate = trimmed(name)
        guard !candidate.isEmpty else { return false }
        return !taken.contains(candidate)
    }
}
