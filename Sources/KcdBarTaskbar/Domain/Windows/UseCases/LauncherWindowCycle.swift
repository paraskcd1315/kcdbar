import Foundation

/** Which of an application's windows a launcher click raises next. */
package enum LauncherWindowCycle {
    package static func next(
        pids: Set<pid_t>,
        onDisplay displayId: Int,
        among windows: [ManagedWindow],
        displays: [DisplayGeometry],
        frontmostPid: pid_t?
    ) -> ManagedWindow? {
        let owned = windows.filter { pids.contains($0.ownerPid) }
        let here = owned.filter {
            WindowDisplayResolver.displayId(for: $0, in: displays) == displayId
        }
        let ordered = cycleOrder(here.isEmpty ? owned : here)
        guard !ordered.isEmpty else { return nil }

        guard let current = ordered.firstIndex(where: {
            WindowFocusPolicy.isFrontmost($0, frontmostPid: frontmostPid, among: windows)
        })
        else {
            return ordered.first
        }

        return ordered[(current + 1) % ordered.count]
    }

    private static func cycleOrder(_ windows: [ManagedWindow]) -> [ManagedWindow] {
        windows.sorted { left, right in
            let leftOrder = left.zOrder ?? Int.max
            let rightOrder = right.zOrder ?? Int.max
            guard leftOrder == rightOrder else { return leftOrder < rightOrder }

            return WindowEntryIdentifier.text(for: left.identity)
                < WindowEntryIdentifier.text(for: right.identity)
        }
    }
}
