import SwiftUI

@MainActor
package protocol UserPicturePort {
    func picture() -> Image?
}
