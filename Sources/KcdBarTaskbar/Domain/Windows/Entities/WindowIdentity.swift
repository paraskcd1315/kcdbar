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

import CoreGraphics

package struct WindowIdentity: Hashable, Sendable {
    package let ownerPid: pid_t
    package let cgWindowId: CGWindowID?
    package let fallbackKey: String

    package init(ownerPid: pid_t, cgWindowId: CGWindowID?, fallbackKey: String) {
        self.ownerPid = ownerPid
        self.cgWindowId = cgWindowId
        self.fallbackKey = fallbackKey
    }

    package static func == (lhs: WindowIdentity, rhs: WindowIdentity) -> Bool {
        guard lhs.ownerPid == rhs.ownerPid else { return false }
        if let left = lhs.cgWindowId, let right = rhs.cgWindowId { return left == right }
        guard lhs.cgWindowId == nil, rhs.cgWindowId == nil else { return false }

        return lhs.fallbackKey == rhs.fallbackKey
    }

    package func hash(into hasher: inout Hasher) {
        hasher.combine(ownerPid)
        if let cgWindowId {
            hasher.combine(cgWindowId)
        } else {
            hasher.combine(fallbackKey)
        }
    }
}
