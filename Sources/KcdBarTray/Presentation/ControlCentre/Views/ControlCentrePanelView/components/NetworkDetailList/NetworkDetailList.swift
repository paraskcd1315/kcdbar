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
        VStack(alignment: .leading, spacing: 0) {
            ForEach(NetworkDetailFields.rows(for: detail)) { field in
                NetworkDetailRow(field: field, onCopy: { onCopy(field.value) })
            }
        }
    }
}
