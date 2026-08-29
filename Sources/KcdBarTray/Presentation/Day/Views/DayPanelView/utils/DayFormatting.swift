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

package enum DayFormatting {
    package static func heading(_ day: Date) -> String {
        day.formatted(.dateTime.weekday(.abbreviated).day().month(.abbreviated))
    }

    package static func hour(_ hour: Int) -> String {
        String(format: "%02d", hour)
    }

    package static func clock(_ moment: Date) -> String {
        moment.formatted(.dateTime.hour().minute())
    }

    package static func range(from started: Date, to ended: Date) -> String {
        "\(clock(started)) – \(clock(ended))"
    }

    package static func label(for entry: DayEntry) -> String {
        entry.jiraKey ?? entry.detail
    }
}
