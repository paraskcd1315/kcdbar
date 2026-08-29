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
