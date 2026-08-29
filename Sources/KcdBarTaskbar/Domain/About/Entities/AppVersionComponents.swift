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

/** The three parts of a KCDBar version: a milestone, a feature within it, and a fix within that. */
package struct AppVersionComponents: Sendable, Equatable {
    package let milestone: Int
    package let feature: Int
    package let fix: Int

    package init(milestone: Int, feature: Int, fix: Int) {
        self.milestone = milestone
        self.feature = feature
        self.fix = fix
    }

    package init?(_ marketing: String) {
        let parts = marketing.split(separator: ".", omittingEmptySubsequences: false)
        guard parts.count == AppVersionMetrics.partCount else { return nil }

        let numbers = parts.compactMap { Int($0) }
        guard numbers.count == AppVersionMetrics.partCount, numbers.allSatisfy({ $0 >= 0 }) else {
            return nil
        }

        self.init(milestone: numbers[0], feature: numbers[1], fix: numbers[2])
    }

    package var text: String {
        "\(milestone).\(feature).\(fix)"
    }

    package var kind: AppReleaseKind {
        if fix > 0 { return .fix }
        if feature > 0 { return .feature }

        return .milestone
    }
}
