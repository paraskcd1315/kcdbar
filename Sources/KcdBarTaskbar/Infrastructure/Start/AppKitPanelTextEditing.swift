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

/** Lends the panel key status while a field is open. */
@MainActor
package struct AppKitPanelTextEditing: PanelTextEditingPort {
    package init() {}

    package func beginEditing() {
        NSApp.activate(ignoringOtherApps: true)
        editable?.makeKeyAndOrderFront(nil)
    }

    package func endEditing() {
        editable?.resignKey()
        NSApp.deactivate()
    }

    private var editable: NSPanel? {
        NSApp.windows
            .compactMap { $0 as? NSPanel }
            .first { $0.isVisible && $0.canBecomeKey }
    }
}
