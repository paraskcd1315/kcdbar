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

/** Turns application bundle paths into the entries the Start menu lists. */
package enum ApplicationBundleReader {
    package static func applications(atPaths paths: [String]) -> [InstalledApplication] {
        let roots = ApplicationDirectories.roots(
            home: FileManager.default.homeDirectoryForCurrentUser
        )

        return paths.compactMap { application(at: URL(fileURLWithPath: $0), underRoots: roots) }
    }

    package static func application(at url: URL, underRoots roots: [URL]) -> InstalledApplication? {
        guard ApplicationBundleFilter.isListable(path: url.path, underRoots: roots),
              let bundle = Bundle(url: url),
              let identifier = bundle.bundleIdentifier,
              !ApplicationBundleFilter.isBackgroundOnly(bundle)
        else {
            return nil
        }

        let raw = bundle.object(forInfoDictionaryKey: ApplicationBundleMetrics.categoryKey) as? String

        return InstalledApplication(
            bundleIdentifier: identifier,
            displayName: BundleDisplayName.of(bundle, url: url),
            path: url.path,
            category: ApplicationCategory.of(raw)
        )
    }
}
