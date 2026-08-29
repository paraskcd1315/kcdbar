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

import Foundation
import KcdBarTray

package struct UserDefaultsDockControl: DockControlPort {
    private let dryRun: Bool

    package init(dryRun: Bool = false) {
        self.dryRun = dryRun
    }

    package func settings() -> DockSettingsSnapshot {
        DockSettingsSnapshot(
            autohide: flag(DockControlKeys.autohide),
            autohideDelay: number(DockControlKeys.autohideDelay),
            autohideTimeModifier: number(DockControlKeys.autohideTimeModifier),
            minimizeEffect: text(DockControlKeys.minimizeEffect),
            orientation: text(DockControlKeys.orientation),
            tilesize: count(DockControlKeys.tilesize),
            largesize: count(DockControlKeys.largesize),
            magnification: flag(DockControlKeys.magnification)
        )
    }

    package func write(_ defaults: [DockDefault]) {
        guard !defaults.isEmpty else { return }
        guard !dryRun else {
            for entry in defaults {
                BarLog.bar.notice(
                    """
                    dock dryRun write key=\(entry.key, privacy: .public) \
                    value=\(Self.described(entry.value), privacy: .public)
                    """)
            }
            return
        }
        for entry in defaults {
            CFPreferencesSetValue(
                entry.key as CFString,
                Self.property(entry.value),
                DockControlKeys.domain as CFString,
                kCFPreferencesCurrentUser,
                kCFPreferencesAnyHost
            )
        }
        CFPreferencesSynchronize(
            DockControlKeys.domain as CFString,
            kCFPreferencesCurrentUser,
            kCFPreferencesAnyHost
        )
    }

    package func restart() {
        guard !dryRun else {
            BarLog.bar.notice("dock dryRun restart")
            return
        }
        let restart = Process()
        restart.executableURL = URL(fileURLWithPath: DockControlKeys.restartExecutable)
        restart.arguments = [DockControlKeys.restartTarget]
        try? restart.run()
    }

    private func copy(_ key: String) -> CFPropertyList? {
        CFPreferencesCopyValue(
            key as CFString,
            DockControlKeys.domain as CFString,
            kCFPreferencesCurrentUser,
            kCFPreferencesAnyHost
        )
    }

    private func flag(_ key: String) -> Bool? {
        guard let held = copy(key) else { return nil }
        return (held as? Bool) ?? (held as? NSNumber)?.boolValue
    }

    private func number(_ key: String) -> Double? {
        guard let held = copy(key) else { return nil }
        return (held as? Double) ?? (held as? NSNumber)?.doubleValue
    }

    private func count(_ key: String) -> Int? {
        guard let held = copy(key) else { return nil }
        return (held as? Int) ?? (held as? NSNumber)?.intValue
    }

    private func text(_ key: String) -> String? {
        copy(key) as? String
    }

    private static func property(_ value: DockDefaultValue?) -> CFPropertyList? {
        switch value {
        case nil: nil
        case .flag(let flag): flag as CFBoolean
        case .number(let number): number as CFNumber
        case .text(let text): text as CFString
        }
    }

    private static func described(_ value: DockDefaultValue?) -> String {
        switch value {
        case nil: "removed"
        case .flag(let flag): String(flag)
        case .number(let number): String(number)
        case .text(let text): text
        }
    }
}
