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

/** Where this machine's cc-console listens, and what it needs to be told. */
package struct ConsoleServer: Equatable, Sendable {
    package let port: Int
    package let token: String

    package init(port: Int, token: String) {
        self.port = port
        self.token = token
    }

    package var ticketUrl: URL? {
        URL(string: "http://\(ConsoleServerMetrics.host):\(port)\(ConsoleServerMetrics.ticketPath)")
    }
}
