import SwiftUI

@MainActor
protocol MenuBarIconPort {
    var isAuthorized: Bool { get }
    func requestAuthorization()
    func icon(for item: MenuBarItem) -> Image?
    func refresh(items: [MenuBarItem]) async
}
