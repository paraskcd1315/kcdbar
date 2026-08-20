import SwiftUI

package struct SettingsPresetLabel: View {
    package let name: String

    package init(name: String) {
        self.name = name
    }

    package var body: some View {
        if BarPresetCatalogue.isBuiltIn(named: name) {
            Text(LocalizedStringKey.catalogue("bar", "preset", name))
        } else {
            Text(verbatim: name)
        }
    }
}
