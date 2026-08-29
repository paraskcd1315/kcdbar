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

package struct WorkspaceApplicationsSource: RunningApplicationsPort {
    package init() {}

    package func currentApplications() -> [RunningApplication] {
        NSWorkspace.shared.runningApplications
            .filter { $0.activationPolicy == .regular }
            .map {
                RunningApplication(
                    pid: $0.processIdentifier,
                    bundleIdentifier: $0.bundleIdentifier,
                    localizedName: $0.localizedName,
                    launchedAt: $0.launchDate
                )
            }
    }

    package var frontmostPid: pid_t? {
        NSWorkspace.shared.frontmostApplication?.processIdentifier
    }
}
