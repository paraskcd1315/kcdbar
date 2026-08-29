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

/** Where the week stands: the five figures that are published, and everything derived from them. */
package struct TrackerPace: Equatable, Sendable {
    package let targetSeconds: Int
    package let workedSeconds: Int
    package let workedTodaySeconds: Int
    package let daysLeft: Int
    package let minimumDaySeconds: Int

    package init(
        targetSeconds: Int,
        workedSeconds: Int,
        workedTodaySeconds: Int,
        daysLeft: Int,
        minimumDaySeconds: Int
    ) {
        self.targetSeconds = targetSeconds
        self.workedSeconds = workedSeconds
        self.workedTodaySeconds = workedTodaySeconds
        self.daysLeft = daysLeft
        self.minimumDaySeconds = minimumDaySeconds
    }

    package var remainingSeconds: Int { max(0, targetSeconds - workedSeconds) }

    package var isOver: Bool { workedSeconds > targetSeconds }

    package var overSeconds: Int { max(0, workedSeconds - targetSeconds) }

    package var todaySeconds: Int {
        guard daysLeft > 0 else { return 0 }

        let evenly = remainingSeconds / daysLeft

        return min(remainingSeconds, max(minimumDaySeconds, evenly))
    }

    package var leftTodaySeconds: Int { max(0, todaySeconds - workedTodaySeconds) }

    package var isBelowFloor: Bool {
        workedTodaySeconds > 0 && workedTodaySeconds < min(minimumDaySeconds, remainingSeconds)
    }
}
