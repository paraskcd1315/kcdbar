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

import Testing
@testable import KcdBarTray

struct SoundMetricsTests {
    @Test func mutedWinsOverEveryVolume() {
        #expect(SoundMetrics.symbol(volume: 1, isMuted: true) == SoundMetrics.mutedSymbol)
        #expect(SoundMetrics.symbol(volume: 0, isMuted: true) == SoundMetrics.mutedSymbol)
    }

    @Test func silenceIsNotTheSameAsMuted() {
        #expect(SoundMetrics.symbol(volume: 0, isMuted: false) == SoundMetrics.quietSymbol)
    }

    @Test func theWavesFollowTheVolume() {
        #expect(SoundMetrics.symbol(volume: 0.3, isMuted: false) == SoundMetrics.mediumSymbol)
        #expect(SoundMetrics.symbol(volume: 0.5, isMuted: false) == SoundMetrics.mediumSymbol)
        #expect(SoundMetrics.symbol(volume: 0.51, isMuted: false) == SoundMetrics.loudSymbol)
        #expect(SoundMetrics.symbol(volume: 1, isMuted: false) == SoundMetrics.loudSymbol)
    }
}
