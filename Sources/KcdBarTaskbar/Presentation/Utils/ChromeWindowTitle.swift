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

/** Chrome titles a window `<page> - Google Chrome - <profile>` for Accessibility; the profile is the last part. */
package enum ChromeWindowTitle {
    package static let separator = " - Google Chrome - "

    package static func profile(of accessibilityTitle: String?) -> String? {
        guard let accessibilityTitle,
              let range = accessibilityTitle.range(of: separator, options: .backwards)
        else {
            return nil
        }
        let profile = accessibilityTitle[range.upperBound...].trimmingCharacters(in: .whitespaces)

        return profile.isEmpty ? nil : profile
    }
}
