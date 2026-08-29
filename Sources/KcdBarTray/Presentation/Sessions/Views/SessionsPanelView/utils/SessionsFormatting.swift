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

package enum SessionsFormatting {
    package static func share(_ context: SessionContext) -> String {
        context.share.formatted(.percent.precision(.fractionLength(0)))
    }

    package static func tokens(_ count: Int) -> String {
        count.formatted(.number.notation(.compactName))
    }

    package static func quiet(_ seconds: TimeInterval) -> String {
        Duration.seconds(max(Int(seconds), 0)).formatted(
            .units(allowed: [.hours, .minutes], width: .narrow)
        )
    }
}
