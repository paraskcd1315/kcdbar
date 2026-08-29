import CoreGraphics
import Foundation

let arguments = CommandLine.arguments.dropFirst().compactMap(Double.init)
guard arguments.count == 2 else {
    print("usage: diagnose-pointer-move.swift <x> <y>   (CoreGraphics coordinates, origin top-left)")
    exit(1)
}
let point = CGPoint(x: arguments[0], y: arguments[1])
CGWarpMouseCursorPosition(point)
guard let move = CGEvent(mouseEventSource: nil, mouseType: .mouseMoved, mouseCursorPosition: point, mouseButton: .left) else {
    print("could not build the event")
    exit(1)
}
move.post(tap: .cghidEventTap)
print("pointer moved to \(Int(point.x)),\(Int(point.y))")
