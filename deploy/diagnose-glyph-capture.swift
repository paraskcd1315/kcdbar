import AppKit
import ApplicationServices
import ScreenCaptureKit

func value(_ e: AXUIElement, _ a: String) -> CFTypeRef? {
    var out: CFTypeRef?
    guard AXUIElementCopyAttributeValue(e, a as CFString, &out) == .success else { return nil }
    return out
}

func frame(of e: AXUIElement) -> CGRect? {
    guard let p = value(e, kAXPositionAttribute), let s = value(e, kAXSizeAttribute) else { return nil }
    var origin = CGPoint.zero
    var size = CGSize.zero
    AXValueGetValue(p as! AXValue, .cgPoint, &origin)
    AXValueGetValue(s as! AXValue, .cgSize, &size)
    return CGRect(origin: origin, size: size)
}

func write(_ image: CGImage, to path: String) {
    let rep = NSBitmapImageRep(cgImage: image)
    try? rep.representation(using: .png, properties: [:])?.write(to: URL(fileURLWithPath: path))
    print("wrote \(path) \(image.width)x\(image.height)")
}

let wanted = CommandLine.arguments.dropFirst().first ?? "Tailscale"
guard let app = NSWorkspace.shared.runningApplications.first(where: {
    ($0.localizedName ?? "").localizedCaseInsensitiveContains(wanted) }),
      let extras = value(AXUIElementCreateApplication(app.processIdentifier), "AXExtrasMenuBar"),
      let item = (value(extras as! AXUIElement, kAXChildrenAttribute) as? [AXUIElement])?.first,
      let rect = frame(of: item)
else {
    print("could not resolve \(wanted)")
    exit(1)
}

print("authorized=\(CGPreflightScreenCaptureAccess())")
print("item frame = \(rect)")

let content = try await SCShareableContent.current
for display in content.displays {
    print("display \(display.displayID) frame=\(display.frame)")
}
guard let display = content.displays.first(where: { $0.frame.intersects(rect) }) ?? content.displays.first
else { exit(1) }

let source = rect.offsetBy(dx: -display.frame.minX, dy: -display.frame.minY)
print("sourceRect = \(source) on display \(display.displayID)")

let filter = SCContentFilter(display: display, excludingApplications: [], exceptingWindows: [])
let configuration = SCStreamConfiguration()
configuration.sourceRect = source
configuration.width = Int(rect.width * 2)
configuration.height = Int(rect.height * 2)
configuration.showsCursor = false
configuration.captureResolution = .best

let shot = try await SCScreenshotManager.captureImage(contentFilter: filter, configuration: configuration)
write(shot, to: "/tmp/kcd-glyph-raw.png")

var pixels = [UInt8](repeating: 0, count: shot.width * shot.height * 4)
let context = CGContext(
    data: &pixels, width: shot.width, height: shot.height, bitsPerComponent: 8,
    bytesPerRow: shot.width * 4, space: CGColorSpaceCreateDeviceRGB(),
    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
)!
context.draw(shot, in: CGRect(x: 0, y: 0, width: shot.width, height: shot.height))

var buckets = [Int](repeating: 0, count: 10)
var alphas = Set<UInt8>()
for p in stride(from: 0, to: pixels.count, by: 4) {
    let l = 0.299 * Double(pixels[p]) + 0.587 * Double(pixels[p + 1]) + 0.114 * Double(pixels[p + 2])
    buckets[min(9, Int(l / 25.6))] += 1
    alphas.insert(pixels[p + 3])
}
print("luminance histogram (0..255 in 10 buckets): \(buckets)")
print("distinct alpha values in capture: \(alphas.sorted().prefix(8))")
