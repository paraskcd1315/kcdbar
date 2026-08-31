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

import ApplicationServices
import CoreGraphics
import Foundation

final class AxLiveWindowProbe: @unchecked Sendable {
    private let lock = NSLock()
    private var held: [CGWindowID: AXUIElement] = [:]

    func hold(_ element: AXUIElement, id: CGWindowID) {
        AXUIElementSetMessagingTimeout(element, WindowMatchingMetrics.accessibilityTimeout)
        lock.lock()
        defer { lock.unlock() }
        held[id] = element
    }

    func liveOmittedIds(listed: Set<CGWindowID>) -> Set<CGWindowID> {
        lock.lock()
        let candidates = held.filter { !listed.contains($0.key) }
        lock.unlock()

        var live: Set<CGWindowID> = []
        var dead: Set<CGWindowID> = []
        for (id, element) in candidates {
            if isDestroyed(element) {
                dead.insert(id)
            } else {
                live.insert(id)
            }
        }

        lock.lock()
        for id in dead {
            held.removeValue(forKey: id)
        }
        lock.unlock()

        return live
    }

    private func isDestroyed(_ element: AXUIElement) -> Bool {
        var value: CFTypeRef?
        return AXUIElementCopyAttributeValue(element, kAXRoleAttribute as CFString, &value)
            == .invalidUIElement
    }
}
