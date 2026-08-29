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

/** Selects a tmux pane and raises whatever terminal is showing it. */
package struct TmuxPaneFocus: PaneFocusPort {
    private let run: @Sendable (String, [String]) async -> Bool
    private let raise: @Sendable () async -> Void

    package init(
        run: @escaping @Sendable (String, [String]) async -> Bool = TmuxPaneFocus.launch,
        raise: @escaping @Sendable () async -> Void = {}
    ) {
        self.run = run
        self.raise = raise
    }

    package func focus(pane: String) async -> Bool {
        guard let target = TmuxTarget.of(pane), let tmux = Self.tmux() else {
            BarLog.bar.notice("pane \(pane, privacy: .public) refused=noTmux")

            return false
        }

        let window = await run(tmux, ["select-window", "-t", target.window])
        let selected = await run(tmux, ["select-pane", "-t", target.pane])

        BarLog.bar.notice(
            "pane \(pane, privacy: .public) window=\(window, privacy: .public) selected=\(selected, privacy: .public)"
        )

        guard window, selected else { return false }

        await raise()

        return true
    }

    private static func tmux() -> String? {
        SessionsMetrics.tmuxPaths.first { FileManager.default.isExecutableFile(atPath: $0) }
    }

    private static let launch: @Sendable (String, [String]) async -> Bool = { path, arguments in
        let process = Process()

        process.executableURL = URL(fileURLWithPath: path)
        process.arguments = arguments
        process.standardOutput = FileHandle.nullDevice
        process.standardError = FileHandle.nullDevice

        do {
            try process.run()
        } catch {
            return false
        }

        process.waitUntilExit()

        return process.terminationStatus == 0
    }
}
