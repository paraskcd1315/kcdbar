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

/** Which windows a Show Desktop hides, and which of them come back. */
package enum ShowDesktopPlan {
    package static func toHide(among entries: [ManagedWindow]) -> [ManagedWindow] {
        entries.filter { !$0.isMinimized && WindowSpacePolicy.isOnActiveSpace($0) }
    }

    package static func toRestore(among windows: [ManagedWindow], hiddenKeys: [String]) -> [ManagedWindow] {
        let wanted = Set(hiddenKeys)

        return windows.filter { wanted.contains(WindowEntryIdentifier.text(for: $0.identity)) }
    }

    package static func keys(of windows: [ManagedWindow]) -> [String] {
        windows.map { WindowEntryIdentifier.text(for: $0.identity) }
    }
}
