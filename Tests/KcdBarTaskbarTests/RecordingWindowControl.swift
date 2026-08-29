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

@testable import KcdBarTaskbar

@MainActor
final class RecordingWindowControl: WindowControlPort {
    private(set) var performed: [(WindowToggleAction, WindowIdentity)] = []
    private(set) var closed: [WindowIdentity] = []
    private(set) var framed: [(CGRect, WindowIdentity)] = []

    func perform(_ action: WindowToggleAction, on window: ManagedWindow) -> Bool {
        performed.append((action, window.identity))

        return true
    }

    func close(_ window: ManagedWindow) -> Bool {
        closed.append(window.identity)

        return true
    }

    func setFrame(_ frame: CGRect, on window: ManagedWindow) -> Bool {
        framed.append((frame, window.identity))

        return true
    }
}
