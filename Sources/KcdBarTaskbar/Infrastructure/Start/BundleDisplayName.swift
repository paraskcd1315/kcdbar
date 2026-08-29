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

import AppKit
import Foundation

/** The name the user sees, preferring the bundle's localized display name. */
package enum BundleDisplayName {
    package static func of(_ bundle: Bundle, url: URL) -> String {
        let localized = bundle.localizedInfoDictionary?[kCFBundleNameKey as String] as? String
        let display = bundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        let name = bundle.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String

        let found = localized ?? display ?? name ?? FileManager.default.displayName(atPath: url.path)

        return ApplicationDisplayName.cleaned(found)
    }
}
