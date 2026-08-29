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
package final class WorkspaceIconSource: ApplicationIconPort {
    private var byPid: [pid_t: Image] = [:]
    private var byBundle: [String: Image] = [:]
    private var themeObserver: NSObjectProtocol?
    private var iconAppearance: String?

    package init() {
        iconAppearance = Self.currentIconAppearance
        themeObserver = DistributedNotificationCenter.default().addObserver(
            forName: Notification.Name(SystemDefaultsKeys.interfaceThemeChanged),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            MainActor.assumeIsolated { self?.forget() }
        }
    }

    private static var currentIconAppearance: String? {
        UserDefaults.standard.string(forKey: SystemDefaultsKeys.iconAppearanceTheme)
    }

    private func forgetIfAppearanceChanged() {
        let current = Self.currentIconAppearance
        guard current != iconAppearance else { return }

        iconAppearance = current
        forget()
    }

    package func icon(forPid pid: pid_t) -> Image? {
        forgetIfAppearanceChanged()

        if let cached = byPid[pid] { return cached }
        guard let application = NSRunningApplication(processIdentifier: pid),
              let icon = application.icon
        else {
            return nil
        }
        let image = Image(nsImage: icon)
        byPid[pid] = image

        return image
    }

    package func icon(forBundleIdentifier bundleIdentifier: String) -> Image? {
        forgetIfAppearanceChanged()

        if let cached = byBundle[bundleIdentifier] { return cached }
        guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleIdentifier)
        else {
            return nil
        }
        let image = Image(nsImage: NSWorkspace.shared.icon(forFile: url.path))
        byBundle[bundleIdentifier] = image

        return image
    }

    private func forget() {
        byPid = [:]
        byBundle = [:]
    }
}
