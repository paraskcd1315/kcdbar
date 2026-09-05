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
import KcdBarDesignSystem
import SwiftUI

package struct ClickCatcherView: NSViewRepresentable {
    package let click: KbClick
    package let action: () -> Void

    package init(click: KbClick, action: @escaping () -> Void) {
        self.click = click
        self.action = action
    }

    package func makeNSView(context: Context) -> ClickCatchingView {
        let view = ClickCatchingView()
        view.click = click
        view.action = action

        return view
    }

    package func updateNSView(_ view: ClickCatchingView, context: Context) {
        view.click = click
        view.action = action
    }
}
