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

/** The band an application falls in when the Start menu groups by category. */
package enum ApplicationCategory: String, CaseIterable, Sendable {
    case productivity
    case creativity
    case developer
    case social
    case entertainment
    case utilities
    case reference
    case other

    package static func of(_ applicationCategoryType: String?) -> ApplicationCategory {
        guard let raw = applicationCategoryType else { return .other }
        let suffix = raw.replacingOccurrences(
            of: ApplicationCategoryMetrics.rawPrefix,
            with: ""
        )
        if let known = ApplicationCategoryMetrics.byRawSuffix[suffix] { return known }
        guard suffix.hasSuffix(ApplicationCategoryMetrics.gameSuffix) else { return .other }

        return .entertainment
    }

    package var titleKey: String { ApplicationCategoryMetrics.titlePrefix + rawValue }
}
