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

package enum ApplicationCategoryMetrics {
    package static let rawPrefix = "public.app-category."
    package static let titlePrefix = "start.category."
    package static let gameSuffix = "games"

    package static let byRawSuffix: [String: ApplicationCategory] = [
        "productivity": .productivity,
        "business": .productivity,
        "finance": .productivity,
        "graphics-design": .creativity,
        "photography": .creativity,
        "video": .creativity,
        "music": .creativity,
        "developer-tools": .developer,
        "social-networking": .social,
        "entertainment": .entertainment,
        "sports": .entertainment,
        "utilities": .utilities,
        "tools": .utilities,
        "weather": .utilities,
        "navigation": .utilities,
        "reference": .reference,
        "education": .reference,
        "books": .reference,
        "news": .reference,
    ]
}
