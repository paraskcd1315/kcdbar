import Foundation

package protocol ApplicationUsageStorePort: Sendable {
    func applicationUsage() async -> [ApplicationUsage]
    func recordLaunch(bundleIdentifier: String, at moment: Date) async
}
