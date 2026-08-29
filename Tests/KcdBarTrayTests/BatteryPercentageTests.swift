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

struct BatteryPercentageTests {
    @Test func aFullBatteryReadsAHundred() {
        #expect(BatteryPercentage.of(capacity: 4200, maximum: 4200) == 100)
    }

    @Test func aHalfBatteryRounds() {
        #expect(BatteryPercentage.of(capacity: 2101, maximum: 4200) == 50)
    }

    @Test func aMissingMaximumCannotDivide() {
        #expect(BatteryPercentage.of(capacity: 100, maximum: 0) == 0)
    }
}
