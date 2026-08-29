import CoreGraphics
import SwiftUI

/** A captured window: the image, and the shape it was captured at. */
package struct WindowPreview: Equatable {
    package let image: Image
    package let pixelSize: CGSize

    package init(image: Image, pixelSize: CGSize) {
        self.image = image
        self.pixelSize = pixelSize
    }
}
