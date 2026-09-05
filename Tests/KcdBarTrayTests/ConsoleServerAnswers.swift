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

@testable import KcdBarTray

final class ConsoleServerAnswers: @unchecked Sendable {
    private let lock = NSLock()
    private var values: [ConsoleServer?]
    private var index = 0

    init(values: [ConsoleServer?]) {
        self.values = values
    }

    var taken: Int { lock.withLock { index } }

    func next() -> ConsoleServer? {
        lock.withLock {
            guard index < values.count else { return nil }

            defer { index += 1 }

            return values[index]
        }
    }
}
