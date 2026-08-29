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

/** One band of the pinned pane: the group that names it and the pins inside it, in order. */
package struct StartPinnedBand: Equatable, Sendable, Identifiable {
    package var group: StartGroup
    package var applications: [InstalledApplication]

    package init(group: StartGroup, applications: [InstalledApplication]) {
        self.group = group
        self.applications = applications
    }

    package var id: String { group.id }
}
