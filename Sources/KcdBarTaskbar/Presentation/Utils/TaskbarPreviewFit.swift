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

/** The size a thumbnail draws at: the window's own shape, no larger than the ceiling. */
package enum TaskbarPreviewFit {
    package static func size(of window: CGSize, within ceiling: CGSize) -> CGSize {
        guard window.width > 0, window.height > 0 else { return ceiling }

        let scale = min(ceiling.width / window.width, ceiling.height / window.height, 1)

        return CGSize(
            width: (window.width * scale).rounded(),
            height: (window.height * scale).rounded()
        )
    }
}
