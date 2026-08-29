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

/** What today and this week come to for one tracker. */
package struct TrackerTotals: Equatable, Sendable {
    package let todaySeconds: Int
    package let weekSeconds: Int
    package let pace: TrackerPace?

    package init(todaySeconds: Int, weekSeconds: Int, pace: TrackerPace?) {
        self.todaySeconds = todaySeconds
        self.weekSeconds = weekSeconds
        self.pace = pace
    }
}
