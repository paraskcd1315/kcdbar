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

package enum SoundMetrics {
    package static let mutedSymbol = "speaker.slash.fill"
    package static let quietSymbol = "speaker.fill"
    package static let mediumSymbol = "speaker.wave.2.fill"
    package static let loudSymbol = "speaker.wave.3.fill"

    package static let quietCeiling = 0.01
    package static let mediumCeiling = 0.5

    package static func symbol(volume: Double, isMuted: Bool) -> String {
        guard !isMuted else { return mutedSymbol }
        if volume <= quietCeiling { return quietSymbol }
        if volume <= mediumCeiling { return mediumSymbol }

        return loudSymbol
    }
}
