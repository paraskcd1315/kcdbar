import Collaboration
import SwiftUI

/** The account picture macOS draws on the login window. */
@MainActor
package struct CollaborationUserPicture: UserPicturePort {
    package init() {}

    package func picture() -> Image? {
        let identity = CBIdentity(
            name: NSUserName(),
            authority: CBIdentityAuthority.default()
        )
        guard let image = identity?.image else { return nil }

        return Image(nsImage: image)
    }
}
