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

/** Which peek the pointer asks for, and when it starts and ends. */
@MainActor
package final class WindowPeekState {
    package private(set) var target: WindowPeekTarget?

    private let delay: Duration
    private let grace: Duration
    private let onChange: (WindowPeekTarget?) -> Void
    private var pendingTarget: WindowPeekTarget?
    private var pending: Task<Void, Never>?

    package init(
        delay: Duration = TaskbarMetrics.peekDelay,
        grace: Duration = TaskbarMetrics.peekGrace,
        onChange: @escaping (WindowPeekTarget?) -> Void
    ) {
        self.delay = delay
        self.grace = grace
        self.onChange = onChange
    }

    package func enter(_ entered: WindowPeekTarget) {
        cancelPending()
        guard target == nil else {
            show(entered)
            return
        }
        pendingTarget = entered
        pending = Task { [weak self, delay] in
            try? await Task.sleep(for: delay)
            guard !Task.isCancelled else { return }

            self?.show(entered)
        }
    }

    package func leave(_ left: WindowPeekTarget) {
        guard left == target || left == pendingTarget else { return }

        cancelPending()
        guard target != nil else { return }

        pending = Task { [weak self, grace] in
            try? await Task.sleep(for: grace)
            guard !Task.isCancelled else { return }

            self?.settle(nil)
        }
    }

    package func end() {
        cancelPending()
        settle(nil)
    }

    private func show(_ shown: WindowPeekTarget) {
        pendingTarget = nil
        pending = nil
        settle(shown)
    }

    private func settle(_ settled: WindowPeekTarget?) {
        guard target != settled else { return }

        target = settled
        onChange(settled)
    }

    private func cancelPending() {
        pending?.cancel()
        pending = nil
        pendingTarget = nil
    }
}
