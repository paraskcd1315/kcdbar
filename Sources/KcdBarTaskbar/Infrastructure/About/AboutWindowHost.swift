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

/** Holds the one About window. */
@MainActor
package final class AboutWindowHost: NSObject, NSWindowDelegate {
    private var window: NSWindow?
    private let version: AppVersionPort

    package init(version: AppVersionPort = BundleAppVersionSource()) {
        self.version = version
        super.init()
    }

    package func present() {
        NSApp.setActivationPolicy(.regular)

        if let window {
            NSApp.activate(ignoringOtherApps: true)
            window.makeKeyAndOrderFront(nil)

            return
        }

        let created = NSWindow(
            contentRect: NSRect(
                x: 0,
                y: 0,
                width: AboutMetrics.windowWidth,
                height: AboutMetrics.windowHeight
            ),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        created.title = String(localized: "about.title")
        created.contentView = NSHostingView(
            rootView: AboutView(
                version: version.current,
                icon: Image(nsImage: NSApp.applicationIconImage)
            )
        )
        created.isReleasedWhenClosed = false
        created.delegate = self
        created.center()
        window = created

        NSApp.activate(ignoringOtherApps: true)
        created.makeKeyAndOrderFront(nil)
    }

    package func windowWillClose(_ notification: Notification) {
        window = nil
        NSApp.setActivationPolicy(.accessory)
    }
}
