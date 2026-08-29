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

package enum WindowFocusPolicy {
    package static func isFrontmost(
        _ window: ManagedWindow,
        frontmostPid: pid_t?,
        among windows: [ManagedWindow]
    ) -> Bool {
        guard window.ownerPid == frontmostPid,
              !window.isMinimized,
              let order = window.zOrder,
              order != Int.max
        else {
            return false
        }
        return siblings(of: window, in: windows).allSatisfy { $0 >= order }
    }

    private static func siblings(of window: ManagedWindow, in windows: [ManagedWindow]) -> [Int] {
        windows
            .filter { $0.ownerPid == window.ownerPid && !$0.isMinimized }
            .compactMap(\.zOrder)
    }
}
