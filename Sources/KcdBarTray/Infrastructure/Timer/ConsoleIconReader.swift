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

import AppKit
import SwiftUI

@MainActor
package final class ConsoleIconReader: ConsoleIconPort {
    private let bundleIdentifier: String
    private var cached: Image?
    private var attempted = false

    package init(bundleIdentifier: String = ConsoleIconMetrics.bundleIdentifier) {
        self.bundleIdentifier = bundleIdentifier
    }

    package func image() -> Image? {
        if let cached { return cached }
        guard !attempted else { return nil }

        attempted = true

        guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleIdentifier)
        else {
            return nil
        }

        let image = Image(nsImage: NSWorkspace.shared.icon(forFile: url.path))
        cached = image

        return image
    }
}
