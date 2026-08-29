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

import SwiftUI

package struct SettingsEnumPicker<Value>: View
where
    Value: CaseIterable & Hashable & RawRepresentable,
    Value.RawValue == String,
    Value.AllCases: RandomAccessCollection {
    package let title: LocalizedStringKey
    package let keyPrefix: String
    @Binding package var selection: Value

    package init(title: LocalizedStringKey, keyPrefix: String, selection: Binding<Value>) {
        self.title = title
        self.keyPrefix = keyPrefix
        self._selection = selection
    }

    package var body: some View {
        Picker(title, selection: $selection) {
            ForEach(Value.allCases, id: \.self) { value in
                Text(LocalizedStringKey.catalogue(keyPrefix, value.rawValue)).tag(value)
            }
        }
    }
}
