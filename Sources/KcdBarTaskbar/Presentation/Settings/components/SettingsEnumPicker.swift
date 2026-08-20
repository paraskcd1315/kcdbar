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
