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

        return Image(nsImage: scaled(image))
    }

    private func scaled(_ image: NSImage) -> NSImage {
        let side = StartMenuMetrics.avatarSize * StartMenuMetrics.avatarScale
        let size = NSSize(width: side, height: side)
        let drawn = NSImage(size: size)

        drawn.lockFocus()
        NSGraphicsContext.current?.imageInterpolation = .high
        NSBezierPath(ovalIn: NSRect(origin: .zero, size: size)).addClip()
        image.draw(in: NSRect(origin: .zero, size: size))
        drawn.unlockFocus()
        drawn.size = NSSize(width: StartMenuMetrics.avatarSize, height: StartMenuMetrics.avatarSize)

        return drawn
    }
}
