import AppKit
import CoreGraphics

/** Rebuilds a captured menu bar glyph as a template image, taking alpha from luminance. */
enum MenuBarGlyphMask {
    static func template(from source: CGImage) -> NSImage? {
        let width = source.width
        let height = source.height
        var pixels = [UInt8](repeating: 0, count: width * height * 4)

        guard let context = CGContext(
            data: &pixels,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            return nil
        }
        context.draw(source, in: CGRect(x: 0, y: 0, width: width, height: height))

        let darkGlyph = mean(of: pixels) > TrayMetrics.glyphLuminanceMidpoint
        for pixel in stride(from: 0, to: pixels.count, by: 4) {
            let coverage = darkGlyph ? 1 - luminance(pixels, pixel) : luminance(pixels, pixel)
            pixels[pixel] = 255
            pixels[pixel + 1] = 255
            pixels[pixel + 2] = 255
            pixels[pixel + 3] = UInt8(max(0, min(1, coverage)) * 255)
        }

        guard let masked = context.makeImage() else { return nil }
        let image = NSImage(cgImage: masked, size: NSSize(width: width, height: height))
        image.isTemplate = true

        return image
    }

    private static func luminance(_ pixels: [UInt8], _ pixel: Int) -> Double {
        let red = Double(pixels[pixel]) / 255
        let green = Double(pixels[pixel + 1]) / 255
        let blue = Double(pixels[pixel + 2]) / 255

        return 0.299 * red + 0.587 * green + 0.114 * blue
    }

    private static func mean(of pixels: [UInt8]) -> Double {
        guard !pixels.isEmpty else { return 0 }
        var total = 0.0
        for pixel in stride(from: 0, to: pixels.count, by: 4) {
            total += luminance(pixels, pixel)
        }

        return total / Double(pixels.count / 4)
    }
}
