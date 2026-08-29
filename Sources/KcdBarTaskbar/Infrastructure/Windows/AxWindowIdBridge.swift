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

import ApplicationServices
import CoreGraphics

@_silgen_name("_AXUIElementGetWindow")
private func AXUIElementGetWindowIdentifier(_ element: AXUIElement, _ identifier: UnsafeMutablePointer<CGWindowID>) -> AXError

package enum AxWindowIdBridge {
    package static func windowId(of element: AXUIElement) -> CGWindowID? {
        var identifier: CGWindowID = 0
        let status = AXUIElementGetWindowIdentifier(element, &identifier)
        guard status == .success, identifier != 0 else { return nil }
        return identifier
    }
}
