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

/** One band of the all-applications list, headed by a letter or by a category's name. */
package struct ApplicationSection: Equatable, Sendable, Identifiable {
    package var key: String
    package var titleKey: String?
    package var applications: [InstalledApplication]

    package init(key: String, titleKey: String? = nil, applications: [InstalledApplication]) {
        self.key = key
        self.titleKey = titleKey
        self.applications = applications
    }

    package var id: String { key }
}
