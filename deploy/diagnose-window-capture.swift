import AppKit
import CoreGraphics
import ScreenCaptureKit

typealias LegacyWindowImage = @convention(c) (
    CGRect, CGWindowListOption, CGWindowID, CGWindowImageOption
) -> Unmanaged<CGImage>?

struct Target {
    let windowID: CGWindowID
    let owner: String
    let title: String?
    let bounds: CGRect
}

func windows(onScreenOnly: Bool) -> [Target] {
    let options: CGWindowListOption = onScreenOnly
        ? [.optionOnScreenOnly, .excludeDesktopElements]
        : [.optionAll, .excludeDesktopElements]
    guard let raw = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as? [[String: Any]] else {
        return []
    }
    return raw.compactMap { entry in
        guard let id = entry[kCGWindowNumber as String] as? CGWindowID,
              let owner = entry[kCGWindowOwnerName as String] as? String,
              let layer = entry[kCGWindowLayer as String] as? Int, layer == 0,
              let boundsDict = entry[kCGWindowBounds as String] as? [String: Any],
              let bounds = CGRect(dictionaryRepresentation: boundsDict as CFDictionary)
        else { return nil }
        guard bounds.width > 200, bounds.height > 200 else { return nil }
        if onScreenOnly == false {
            let onScreen = entry[kCGWindowIsOnscreen as String] as? Bool ?? false
            guard onScreen == false else { return nil }
        }
        return Target(
            windowID: id,
            owner: owner,
            title: entry[kCGWindowName as String] as? String,
            bounds: bounds
        )
    }
}

func distinctSampledColours(_ image: CGImage) -> Int {
    let side = 16
    var pixels = [UInt32](repeating: 0, count: side * side)
    guard let context = CGContext(
        data: &pixels,
        width: side,
        height: side,
        bitsPerComponent: 8,
        bytesPerRow: side * 4,
        space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
    ) else { return -1 }
    context.draw(image, in: CGRect(x: 0, y: 0, width: side, height: side))
    return Set(pixels).count
}

func reportLegacy(_ targets: [Target]) {
    guard let handle = dlopen(
        "/System/Library/Frameworks/CoreGraphics.framework/CoreGraphics", RTLD_NOW
    ) else {
        print("legacy dlopen=failed")
        return
    }
    guard let symbol = dlsym(handle, "CGWindowListCreateImage") else {
        print("legacy dlsym=absent")
        return
    }
    let capture = unsafeBitCast(symbol, to: LegacyWindowImage.self)
    print("legacy dlsym=present")
    for target in targets.prefix(4) {
        guard let image = capture(
            .null, .optionIncludingWindow, target.windowID, [.boundsIgnoreFraming]
        )?.takeRetainedValue() else {
            print("legacy owner=\(target.owner) id=\(target.windowID) image=nil")
            continue
        }
        let colours = distinctSampledColours(image)
        print(
            "legacy owner=\(target.owner) id=\(target.windowID) "
                + "size=\(image.width)x\(image.height) distinctSampledColours=\(colours)"
        )
    }
}

func reportShareableContent() async {
    do {
        let content = try await SCShareableContent.excludingDesktopWindows(
            true, onScreenWindowsOnly: true
        )
        print("sckit windows=\(content.windows.count) displays=\(content.displays.count)")
        let named = content.windows.filter { ($0.title ?? "").isEmpty == false }
        print("sckit windowsWithTitle=\(named.count)")
        guard let window = content.windows.first(where: { $0.frame.width > 200 }) else {
            print("sckit screenshot=noCandidate")
            return
        }
        let filter = SCContentFilter(desktopIndependentWindow: window)
        let configuration = SCStreamConfiguration()
        configuration.width = Int(window.frame.width)
        configuration.height = Int(window.frame.height)
        let image = try await SCScreenshotManager.captureImage(
            contentFilter: filter, configuration: configuration
        )
        print(
            "sckit screenshot owner=\(window.owningApplication?.applicationName ?? "?") "
                + "size=\(image.width)x\(image.height) "
                + "distinctSampledColours=\(distinctSampledColours(image))"
        )
    } catch {
        print("sckit error=\(error)")
    }
}

func reportOffScreen(_ targets: [Target]) async {
    print("offScreen count=\(targets.count)")
    for target in targets.prefix(4) {
        print("  offScreen owner=\(target.owner) id=\(target.windowID) title=\(target.title ?? "<nil>")")
    }
    guard let target = targets.first else { return }
    do {
        let content = try await SCShareableContent.excludingDesktopWindows(
            true, onScreenWindowsOnly: false
        )
        let match = content.windows.first { $0.windowID == target.windowID }
        print("offScreen sckitListsIt=\(match != nil)")
        guard let window = match else { return }
        let filter = SCContentFilter(desktopIndependentWindow: window)
        let configuration = SCStreamConfiguration()
        configuration.width = Int(target.bounds.width)
        configuration.height = Int(target.bounds.height)
        let image = try await SCScreenshotManager.captureImage(
            contentFilter: filter, configuration: configuration
        )
        print(
            "offScreen sckitCapture size=\(image.width)x\(image.height) "
                + "distinctSampledColours=\(distinctSampledColours(image))"
        )
    } catch {
        print("offScreen sckit error=\(error)")
    }
}

let mine = ProcessInfo.processInfo.processName
let others = windows(onScreenOnly: true).filter { $0.owner != mine }
let offScreen = windows(onScreenOnly: false).filter { $0.owner != mine }
let titled = others.filter { ($0.title?.isEmpty == false) }

print("host=\(ProcessInfo.processInfo.hostName)")
print("preflight=\(CGPreflightScreenCaptureAccess())")
print("cgWindows other=\(others.count) withTitle=\(titled.count)")
for target in others.prefix(6) {
    print("  cg owner=\(target.owner) id=\(target.windowID) title=\(target.title ?? "<nil>")")
}

reportLegacy(others)
reportLegacy(offScreen)

let done = DispatchSemaphore(value: 0)
Task {
    await reportShareableContent()
    await reportOffScreen(offScreen)
    done.signal()
}
done.wait()
