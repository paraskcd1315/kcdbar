import SwiftUI

struct WifiOtherList: View {
    let monitor: WifiMonitor

    var body: some View {
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
