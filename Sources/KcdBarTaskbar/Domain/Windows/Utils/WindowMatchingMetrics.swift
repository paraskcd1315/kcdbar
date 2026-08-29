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

package enum WindowMatchingMetrics {
    package static let boundsTolerance: CGFloat = 4
    package static let normalWindowLayer = 0
    package static let minimumManageableSize = CGSize(width: 40, height: 40)
    package static let fullScreenAttribute = "AXFullScreen"
    package static let windowRole = "AXWindow"
    package static let switchableSubroles: Set<String> = ["AXStandardWindow", "AXDialog"]
    package static let accessibilityTimeout: Float = 0.2
    package static let remoteElementBudget: Double = 0.25
}
