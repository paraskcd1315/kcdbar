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

/** What a category folder shows on its face — its first apps, with the remainder sharing one cell. */
package enum ApplicationFolderPreview {
    package static func cells(of applications: [InstalledApplication]) -> [[InstalledApplication]] {
        let slots = StartMenuMetrics.folderPreviewCount
        guard applications.count > slots else { return applications.map { [$0] } }

        let leading = applications.prefix(slots - 1).map { [$0] }

        return leading + [Array(applications.dropFirst(slots - 1))]
    }
}
