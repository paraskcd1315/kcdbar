import CoreGraphics

package enum WindowReconciler {
    package static func reconcile(
        coreGraphics: [CgWindowRecord],
        accessibility: AxWindowScan,
        previous: [ManagedWindow]
    ) -> [ManagedWindow] {
        let manageable = coreGraphics.filter(isManageable)
        var unmatched = accessibility.records.filter(AxWindowClassification.isSwitchable)
        var reconciled: [ManagedWindow] = []

        for record in manageable.sorted(by: { $0.zOrder < $1.zOrder }) {
            let matchIndex = indexOfMatch(for: record, in: unmatched)
            let match = matchIndex.map { unmatched.remove(at: $0) }
            reconciled.append(
                merge(
                    coreGraphics: record,
                    accessibility: match,
                    answered: accessibility.answeredPids.contains(record.ownerPid),
                    liveOmitted: accessibility.liveOmittedIds.contains(record.windowId),
                    previous: previous
                )
            )
        }

        for record in unmatched where record.isMinimized {
            reconciled.append(promote(accessibility: record, previous: previous))
        }

        return reconciled
    }

    package static func isManageable(_ record: CgWindowRecord) -> Bool {
        record.layer == WindowMatchingMetrics.normalWindowLayer
            && record.bounds.width >= WindowMatchingMetrics.minimumManageableSize.width
            && record.bounds.height >= WindowMatchingMetrics.minimumManageableSize.height
    }

    private static func indexOfMatch(for record: CgWindowRecord, in candidates: [AxWindowRecord]) -> Int? {
        if let index = candidates.firstIndex(where: { $0.cgWindowId == record.windowId }) {
            return index
        }
        let samePid = candidates.enumerated().filter {
            $0.element.ownerPid == record.ownerPid && $0.element.cgWindowId == nil
        }
        if let title = record.title, !title.isEmpty,
           let entry = samePid.first(where: { $0.element.title == title }) {
            return entry.offset
        }
        if let entry = samePid.first(where: { hasSameBounds($0.element.bounds, record.bounds) }) {
            return entry.offset
        }
        return nil
    }

    private static func hasSameBounds(_ lhs: CGRect?, _ rhs: CGRect) -> Bool {
        guard let lhs else { return false }
        let tolerance = WindowMatchingMetrics.boundsTolerance
        return abs(lhs.origin.x - rhs.origin.x) <= tolerance
            && abs(lhs.origin.y - rhs.origin.y) <= tolerance
            && abs(lhs.width - rhs.width) <= tolerance
            && abs(lhs.height - rhs.height) <= tolerance
    }

    private static func merge(
        coreGraphics record: CgWindowRecord,
        accessibility match: AxWindowRecord?,
        answered: Bool,
        liveOmitted: Bool,
        previous: [ManagedWindow]
    ) -> ManagedWindow {
        let identity = WindowIdentity(
            ownerPid: record.ownerPid,
            cgWindowId: record.windowId,
            fallbackKey: fallbackKey(pid: record.ownerPid, bounds: record.bounds)
        )
        let earlier = previous.first { $0.identity == identity }
        let wasConfirmed = earlier?.source == .both && (!answered || liveOmitted)

        return ManagedWindow(
            identity: identity,
            ownerPid: record.ownerPid,
            ownerName: record.ownerName,
            title: preferredTitle(record.title, match?.title, previous: previous, identity: identity),
            bounds: record.bounds,
            isMinimized: match?.isMinimized ?? earlier?.isMinimized ?? false,
            isFullScreen: match?.isFullScreen ?? earlier?.isFullScreen ?? false,
            isOnScreen: record.isOnScreen,
            zOrder: record.zOrder,
            source: match == nil && !wasConfirmed ? .coreGraphicsOnly : .both
        )
    }

    private static func promote(accessibility record: AxWindowRecord, previous: [ManagedWindow]) -> ManagedWindow {
        let identity = resolvedIdentity(for: record, previous: previous)
        return ManagedWindow(
            identity: identity,
            ownerPid: record.ownerPid,
            ownerName: previous.first { $0.identity == identity }?.ownerName,
            title: record.title,
            bounds: record.bounds,
            isMinimized: true,
            isFullScreen: false,
            isOnScreen: false,
            zOrder: nil,
            source: .accessibilityOnly
        )
    }

    private static func resolvedIdentity(for record: AxWindowRecord, previous: [ManagedWindow]) -> WindowIdentity {
        if let windowId = record.cgWindowId {
            return WindowIdentity(
                ownerPid: record.ownerPid,
                cgWindowId: windowId,
                fallbackKey: fallbackKey(pid: record.ownerPid, index: record.indexInApplication)
            )
        }
        if let title = record.title, !title.isEmpty,
           let earlier = previous.first(where: { $0.ownerPid == record.ownerPid && $0.title == title }) {
            return earlier.identity
        }
        return WindowIdentity(
            ownerPid: record.ownerPid,
            cgWindowId: nil,
            fallbackKey: fallbackKey(pid: record.ownerPid, index: record.indexInApplication)
        )
    }

    private static func preferredTitle(
        _ cgTitle: String?,
        _ axTitle: String?,
        previous: [ManagedWindow],
        identity: WindowIdentity
    ) -> String? {
        if let cgTitle, !cgTitle.isEmpty { return cgTitle }
        if let axTitle, !axTitle.isEmpty { return axTitle }
        return previous.first { $0.identity == identity }?.title
    }

    private static func fallbackKey(pid: pid_t, bounds: CGRect) -> String {
        "\(pid):\(Int(bounds.origin.x)):\(Int(bounds.origin.y))"
    }

    private static func fallbackKey(pid: pid_t, index: Int) -> String {
        "\(pid):ax\(index)"
    }
}
