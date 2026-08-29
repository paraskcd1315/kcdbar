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

/** Reads the running build's version out of the main bundle. */
package struct BundleAppVersionSource: AppVersionPort {
    private let bundle: Bundle

    package init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    package var current: AppVersion {
        AppVersion(
            marketing: string(AppVersionKeys.marketing),
            build: string(AppVersionKeys.build),
            commit: string(AppVersionKeys.commit)
        )
    }

    private func string(_ key: String) -> String {
        bundle.object(forInfoDictionaryKey: key) as? String ?? ""
    }
}
