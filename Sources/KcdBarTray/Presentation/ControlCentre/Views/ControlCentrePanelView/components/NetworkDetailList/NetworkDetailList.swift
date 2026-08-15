import KcdBarDesignSystem
import SwiftUI

package struct NetworkDetailList: View {
    package let detail: NetworkDetail
    package let onCopy: (String) -> Void

    package init(detail: NetworkDetail, onCopy: @escaping (String) -> Void) {
        self.detail = detail
        self.onCopy = onCopy
    }

    package var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(rows) { field in
                    NetworkDetailRow(field: field, onCopy: { onCopy(field.value) })
                }
            }
        }
        .frame(
            height: KbControlCentreMetrics.listHeight(
                rows: rows.count,
                cap: KbControlCentreMetrics.detailMaxHeight
            )
        )
        .scrollBounceBehavior(.basedOnSize)
    }

    private var rows: [NetworkDetailField] {
        NetworkDetailFields.rows(for: detail)
    }
}
