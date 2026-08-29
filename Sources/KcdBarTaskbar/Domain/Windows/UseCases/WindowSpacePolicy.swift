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

/** Whether a window sits on the Space the user is looking at. */
package enum WindowSpacePolicy {
    package static func isOnActiveSpace(_ window: ManagedWindow) -> Bool {
        guard window.source != .inactiveSpace, let order = window.zOrder else { return false }

        return order != Int.max
    }
}
