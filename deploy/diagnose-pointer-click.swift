import CoreGraphics
import Foundation

let arguments = CommandLine.arguments.dropFirst().compactMap(Double.init)
guard arguments.count == 2 else {
    print("usage: diagnose-pointer-click.swift <x> <y>   (CoreGraphics coordinates, origin top-left)")
    exit(1)
}
let point = CGPoint(x: arguments[0], y: arguments[1])
CGWarpMouseCursorPosition(point)
for type in [CGEventType.mouseMoved, .leftMouseDown, .leftMouseUp] {
    guard let event = CGEvent(mouseEventSource: nil, mouseType: type, mouseCursorPosition: point, mouseButton: .left) else {
        print("could not build \(type.rawValue)")
        exit(1)
    }
    event.post(tap: .cghidEventTap)
    Thread.sleep(forTimeInterval: 0.05)
}
print("clicked \(Int(point.x)),\(Int(point.y))")
