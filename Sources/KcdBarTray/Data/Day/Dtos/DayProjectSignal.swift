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

/** A project a day's entries were booked against, as the channel writes it. */
package struct DayProjectSignal: Codable, Sendable, Equatable {
    package let id: Int
    package let name: String
    package let clientName: String?
    package let colour: String

    package func toEntity() -> DayProject {
        DayProject(id: id, name: name, clientName: clientName, colour: colour)
    }
}
