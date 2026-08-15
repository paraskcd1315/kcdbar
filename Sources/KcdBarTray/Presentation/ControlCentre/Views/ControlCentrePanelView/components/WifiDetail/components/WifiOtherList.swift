import SwiftUI

package struct WifiOtherList: View {
    package let monitor: WifiMonitor

    package var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                WifiNearbyList(monitor: monitor)
            }
        }
        .frame(
            height: WifiMetrics.listHeight(
                rows: max(monitor.nearby.count, 1),
                cap: KbControlCentreMetrics.listMaxHeight
            )
        )
        .scrollBounceBehavior(.basedOnSize)
    }
}
