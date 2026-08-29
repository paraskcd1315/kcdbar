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

package enum TimerFormatting {
    package static func duration(_ seconds: TimeInterval) -> String {
        let total = max(Int(seconds), 0)
        let hours = total / TimerReadoutMetrics.secondsInHour
        let minutes =
            (total / TimerReadoutMetrics.secondsInMinute) % TimerReadoutMetrics.secondsInMinute
        let remainder = total % TimerReadoutMetrics.secondsInMinute

        guard hours > 0 else { return String(format: "%d:%02d", minutes, remainder) }

        return String(format: "%d:%02d:%02d", hours, minutes, remainder)
    }

    package static func elapsed(since started: Date, at moment: Date) -> String {
        duration(moment.timeIntervalSince(started))
    }

    package static func label(for timer: RunningTimer) -> String {
        timer.jiraKey ?? timer.detail
    }

    package static func compact(_ seconds: Int) -> String {
        Duration.seconds(max(seconds, 0)).formatted(
            .units(allowed: [.hours, .minutes], width: .narrow)
        )
    }
}
