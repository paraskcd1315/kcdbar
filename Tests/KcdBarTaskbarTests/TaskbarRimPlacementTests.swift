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
import Testing
@testable import KcdBarTaskbar

struct TaskbarRimPlacementTests {
    private let measured = CGRect(x: 0, y: 40, width: 1920, height: 62)

    @Test func anAttachedBarWearsTheRimOnItsWholeFrame() {
        let rect = TaskbarRimPlacement.rect(measured: measured, attachment: .edgeAttached)

        #expect(rect == measured)
    }

    @Test func aFloatingBarWearsTheRimInsideItsOutset() {
        let rect = TaskbarRimPlacement.rect(measured: measured, attachment: .floating)

        #expect(rect == measured.insetBy(dx: TaskbarMetrics.islandOutset, dy: TaskbarMetrics.islandOutset))
    }

    @Test func aBarNotYetMeasuredHasNoRim() {
        #expect(TaskbarRimPlacement.rect(measured: nil, attachment: .edgeAttached) == nil)
        #expect(TaskbarRimPlacement.rect(measured: .zero, attachment: .edgeAttached) == nil)
    }
}
