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

/** Hosts a popover's content and reports the size that content asks for. */
package final class PopoverHostingView<Content: View>: NSHostingView<Content> {
    package var onContentSizeChange: ((CGSize) -> Void)?

    private var reported: CGSize = .zero

    package required init(rootView: Content) {
        super.init(rootView: rootView)
        sizingOptions = [.intrinsicContentSize]
    }

    @available(*, unavailable)
    package required init?(coder: NSCoder) {
        fatalError("init(coder:) is not available")
    }

    package override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()

        Task { [weak self] in self?.report() }
    }

    package override func layout() {
        super.layout()
        report()
    }

    package override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        true
    }

    private func report() {
        let wanted = intrinsicContentSize
        guard wanted.width > 0, wanted.height > 0 else { return }
        guard !PopoverSizing.isSettled(wanted, against: reported) else { return }

        reported = wanted
        onContentSizeChange?(wanted)
    }
}
