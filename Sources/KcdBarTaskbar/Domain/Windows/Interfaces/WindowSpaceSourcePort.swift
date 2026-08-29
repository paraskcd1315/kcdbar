import CoreGraphics

/** Which of these windows sit on a Space that is not their display's current one. */
@MainActor
package protocol WindowSpaceSourcePort {
    func windowsOnInactiveSpaces(among windowIds: [CGWindowID]) -> Set<CGWindowID>
}
