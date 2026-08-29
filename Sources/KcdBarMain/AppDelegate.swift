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
import KcdBarTaskbar

@MainActor
package final class AppDelegate: NSObject, NSApplicationDelegate {
    private let services = AppServices()

    package func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        if !services.authorization.isTrusted {
            services.authorization.requestTrust()
        }

        services.trash.start()
        services.timer.start()
        services.totals.start()
        services.day.start()
        services.sessions.start()
        Task { await services.start() }
        services.changes.startObserving { [services] in
            services.scheduleRefresh()
        }
    }

    package func applicationShouldTerminate(
        _ sender: NSApplication
    ) -> NSApplication.TerminateReply {
        Task { [services] in
            await services.restoreDock()
            NSApp.reply(toApplicationShouldTerminate: true)
        }

        return .terminateLater
    }

    package func applicationWillTerminate(_ notification: Notification) {
        services.stopObserving()
        services.timer.stop()
        services.totals.stop()
        services.day.stop()
        services.sessions.stop()
        services.bar?.dismiss()
    }
}
