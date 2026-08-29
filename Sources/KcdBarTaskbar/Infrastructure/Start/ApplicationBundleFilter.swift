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

/** Which application bundles a launcher lists — not helpers, not agents, not build products. */
package enum ApplicationBundleFilter {
    package static func isListable(path: String, underRoots roots: [URL]) -> Bool {
        guard !path.contains(ApplicationBundleMetrics.embeddedMarker) else { return false }

        return roots.contains { path.hasPrefix($0.path + "/") }
    }

    package static func isBackgroundOnly(_ bundle: Bundle) -> Bool {
        ApplicationBundleMetrics.backgroundKeys.contains {
            isTrue(bundle.object(forInfoDictionaryKey: $0))
        }
    }

    package static func isTrue(_ value: Any?) -> Bool {
        if let flag = value as? Bool { return flag }
        if let number = value as? NSNumber { return number.boolValue }
        if let text = value as? String {
            return ApplicationBundleMetrics.trueStrings.contains(text.lowercased())
        }

        return false
    }
}
