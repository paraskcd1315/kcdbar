import AppKit

typealias DefaultConnection = @convention(c) () -> Int32
typealias CopySpacesForWindows = @convention(c) (Int32, Int32, CFArray) -> Unmanaged<CFArray>?
typealias CopyManagedDisplayForSpace = @convention(c) (Int32, UInt64) -> Unmanaged<CFString>?
typealias SetCurrentSpace = @convention(c) (Int32, CFString, UInt64) -> Void
typealias CaptureWindowList = @convention(c) (Int32, UnsafePointer<UInt32>, Int32, UInt32) -> Unmanaged<CFArray>?

let arguments = CommandLine.arguments.dropFirst()
guard let windowId = arguments.first.flatMap({ UInt32($0) }) else {
    print("usage: diagnose-space-switch.swift <windowId> [switch] [capture]")
    exit(1)
}
guard let skylight = dlopen("/System/Library/PrivateFrameworks/SkyLight.framework/SkyLight", RTLD_NOW),
      let connectionSymbol = dlsym(skylight, "CGSMainConnectionID"),
      let spacesSymbol = dlsym(skylight, "CGSCopySpacesForWindows")
else {
    print("SkyLight symbols absent")
    exit(1)
}
let connection = unsafeBitCast(connectionSymbol, to: DefaultConnection.self)()
let spaces = unsafeBitCast(spacesSymbol, to: CopySpacesForWindows.self)
let ids = [NSNumber(value: windowId)] as CFArray
let found = spaces(connection, 7, ids)?.takeRetainedValue() as? [UInt64] ?? []
print("window \(windowId) spaces=\(found)")

if arguments.contains("switch"), let space = found.first,
   let displaySymbol = dlsym(skylight, "CGSCopyManagedDisplayForSpace"),
   let switchSymbol = dlsym(skylight, "CGSManagedDisplaySetCurrentSpace") {
    let display = unsafeBitCast(displaySymbol, to: CopyManagedDisplayForSpace.self)(connection, space)?.takeRetainedValue()
    print("space \(space) display=\(display.map { $0 as String } ?? "nil")")
    if let display {
        unsafeBitCast(switchSymbol, to: SetCurrentSpace.self)(connection, display, space)
        print("switched")
    }
}

if arguments.contains("capture"), let captureSymbol = dlsym(skylight, "CGSHWCaptureWindowList") {
    var list: [UInt32] = [windowId]
    let images = unsafeBitCast(captureSymbol, to: CaptureWindowList.self)(connection, &list, 1, 1 << 11)?.takeRetainedValue() as? [CGImage] ?? []
    for image in images {
        print("captured \(image.width)x\(image.height)")
    }
    if images.isEmpty { print("capture answered nothing") }
}
