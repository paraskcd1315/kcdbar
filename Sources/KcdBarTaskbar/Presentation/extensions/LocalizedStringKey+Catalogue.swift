import SwiftUI

extension LocalizedStringKey {
    /** A catalogue key composed from dotted parts. */
    package static func catalogue(_ parts: String...) -> LocalizedStringKey {
        LocalizedStringKey(parts.joined(separator: "."))
    }
}
