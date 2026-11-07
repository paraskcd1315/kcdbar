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

@MainActor
struct WindowPeekStateTests {
    private final class Recorder {
        var changes: [WindowPeekTarget?] = []
    }

    private func settled() async {
        try? await Task.sleep(for: .milliseconds(40))
    }

    private func state(delay: Duration = .zero, grace: Duration = .zero, recorder: Recorder) -> WindowPeekState {
        WindowPeekState(delay: delay, grace: grace) { recorder.changes.append($0) }
    }

    @Test func restingOnATilePeeksItsWindowOnceTheDelayPasses() async {
        let recorder = Recorder()
        let peek = state(recorder: recorder)

        peek.enter(.window(1))
        await settled()

        #expect(peek.target == .window(1))
        #expect(recorder.changes == [.window(1)])
    }

    @Test func passingOverATileBeforeTheDelayPeeksNothing() async {
        let recorder = Recorder()
        let peek = state(delay: .milliseconds(20), recorder: recorder)

        peek.enter(.window(1))
        peek.leave(.window(1))
        await settled()

        #expect(peek.target == nil)
        #expect(recorder.changes.isEmpty)
    }

    @Test func leavingThePeekedTileRestoresTheScreenOnceTheGracePasses() async {
        let recorder = Recorder()
        let peek = state(recorder: recorder)
        peek.enter(.window(1))
        await settled()

        peek.leave(.window(1))
        await settled()

        #expect(peek.target == nil)
        #expect(recorder.changes == [.window(1), nil])
    }

    @Test func movingToTheNextTileSwitchesThePeekWithoutRestoringFirst() async {
        let recorder = Recorder()
        let peek = state(delay: .milliseconds(20), grace: .milliseconds(20), recorder: recorder)
        peek.enter(.window(1))
        await settled()

        peek.leave(.window(1))
        peek.enter(.window(2))

        #expect(peek.target == .window(2))
        await settled()
        #expect(recorder.changes == [.window(1), .window(2)])
    }

    @Test func endingThePeekRestoresTheScreenAtOnce() async {
        let recorder = Recorder()
        let peek = state(recorder: recorder)
        peek.enter(.desktop)
        await settled()

        peek.end()

        #expect(peek.target == nil)
        #expect(recorder.changes == [.desktop, nil])
    }

    @Test func leavingATargetThatIsNotPeekedChangesNothing() async {
        let recorder = Recorder()
        let peek = state(recorder: recorder)
        peek.enter(.window(1))
        await settled()

        peek.leave(.desktop)
        await settled()

        #expect(peek.target == .window(1))
        #expect(recorder.changes == [.window(1)])
    }
}
