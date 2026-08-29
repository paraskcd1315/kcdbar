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

import CoreGraphics
import Observation

/** Where the bar and its tooltip are drawn inside the panel — the click-through margins and the rim both read it. */
@MainActor
@Observable
package final class BarFrameState {
    package var frame: CGRect?
    package var tooltipFrame: CGRect?

    package init(frame: CGRect? = nil) {
        self.frame = frame
    }
}
