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

package enum SessionsCopy {
    package static func standing(_ standing: SessionStanding) -> String {
        NSLocalizedString(key(of: standing), bundle: .main, comment: "")
    }

    private static func key(of standing: SessionStanding) -> String {
        switch standing {
        case .busy: "sessions.standing.busy"
        case .shell: "sessions.standing.shell"
        case .idle: "sessions.standing.idle"
        case .waiting: "sessions.standing.waiting"
        }
    }
}
