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

/** The week's five published figures. */
package struct PaceSignal: Codable, Sendable, Equatable {
    package let targetSeconds: Int
    package let workedSeconds: Int
    package let workedTodaySeconds: Int
    package let daysLeft: Int
    package let minimumDaySeconds: Int

    package func toEntity() -> TrackerPace {
        TrackerPace(
            targetSeconds: targetSeconds,
            workedSeconds: workedSeconds,
            workedTodaySeconds: workedTodaySeconds,
            daysLeft: daysLeft,
            minimumDaySeconds: minimumDaySeconds
        )
    }
}
