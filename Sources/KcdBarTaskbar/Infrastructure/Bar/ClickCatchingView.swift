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
import KcdBarDesignSystem

package final class ClickCatchingView: NSView {
    package var click: KbClick = .middle
    package var action: (() -> Void)?

    package override func otherMouseUp(with event: NSEvent) {
        guard click == .middle,
              event.buttonNumber == MiddleClickMetrics.buttonNumber,
              holds(event)
        else {
            super.otherMouseUp(with: event)
            return
        }
        action?()
    }

    package override func rightMouseUp(with event: NSEvent) {
        guard click == .secondary, holds(event) else {
            super.rightMouseUp(with: event)
            return
        }
        action?()
    }

    package override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        true
    }

    package override var acceptsFirstResponder: Bool {
        false
    }

    private func holds(_ event: NSEvent) -> Bool {
        bounds.contains(convert(event.locationInWindow, from: nil))
    }
}
