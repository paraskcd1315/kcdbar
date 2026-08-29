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
import Observation

/** The windows KCDBar minimized to show the desktop, so the same click can put them back. */
@MainActor
@Observable
package final class ShowDesktopState {
    package init() {}

    package private(set) var hiddenKeys: [String] = []
    package private(set) var systemShowingDesktop = false

    package var isShowingDesktop: Bool { systemShowingDesktop || !hiddenKeys.isEmpty }

    package func setSystemShowingDesktop(_ showing: Bool) {
        systemShowingDesktop = showing
    }

    package func remember(keys: [String]) {
        hiddenKeys = keys
    }

    package func clear() {
        hiddenKeys = []
    }
}
