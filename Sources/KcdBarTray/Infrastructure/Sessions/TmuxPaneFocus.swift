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
