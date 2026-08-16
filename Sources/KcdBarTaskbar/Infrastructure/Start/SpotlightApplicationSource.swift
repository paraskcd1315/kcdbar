import Foundation

/** Spotlight's index of application bundles, and the signal that one was installed or removed. */
@MainActor
package final class SpotlightApplicationSource: ApplicationCataloguePort, ApplicationCatalogueWatchPort {
    private let query = NSMetadataQuery()
    private var waiting: [CheckedContinuation<Void, Never>] = []
    private var hasGathered = false
    private var onChange: (@MainActor () -> Void)?
    private var observers: [any NSObjectProtocol] = []

    package init() {
        query.predicate = NSPredicate(
            format: "%K == %@",
            NSMetadataItemContentTypeKey,
            SpotlightApplicationMetrics.applicationBundleType
        )
        query.searchScopes = SpotlightApplicationMetrics.scopes
        observe()
    }

    package func installedApplications() async -> [InstalledApplication] {
        await gather()
        let paths = indexedPaths()

        return await Task.detached(priority: .userInitiated) {
            ApplicationBundleReader.applications(atPaths: paths)
        }.value
    }

    package func watch(_ onChange: @escaping @MainActor () -> Void) {
        self.onChange = onChange
    }

    package func stopWatching() {
        onChange = nil
    }

    private func gather() async {
        guard !hasGathered else { return }

        await withCheckedContinuation { continuation in
            guard query.isStarted || query.start() else {
                continuation.resume()
                return
            }
            waiting.append(continuation)
        }
    }

    private func indexedPaths() -> [String] {
        query.disableUpdates()
        defer { query.enableUpdates() }

        return (0..<query.resultCount).compactMap {
            let item = query.result(at: $0) as? NSMetadataItem

            return item?.value(forAttribute: NSMetadataItemPathKey) as? String
        }
    }

    private func observe() {
        let center = NotificationCenter.default
        observers.append(
            center.addObserver(
                forName: .NSMetadataQueryDidFinishGathering,
                object: query,
                queue: .main
            ) { [weak self] _ in
                MainActor.assumeIsolated { self?.finishGathering() }
            }
        )
        observers.append(
            center.addObserver(
                forName: .NSMetadataQueryDidUpdate,
                object: query,
                queue: .main
            ) { [weak self] _ in
                MainActor.assumeIsolated { self?.onChange?() }
            }
        )
    }

    private func finishGathering() {
        hasGathered = true
        let pending = waiting
        waiting = []
        for continuation in pending {
            continuation.resume()
        }
    }

    isolated deinit {
        for observer in observers {
            NotificationCenter.default.removeObserver(observer)
        }
        query.stop()
    }
}
