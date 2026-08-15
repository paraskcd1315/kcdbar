import CoreGraphics

enum WindowFixtures {
    static let defaultBounds = CGRect(x: 0, y: 0, width: 800, height: 600)

    static func cgRecord(
        windowId: CGWindowID,
        pid: pid_t,
        title: String?,
        bounds: CGRect = defaultBounds,
        layer: Int = 0,
        isOnScreen: Bool = true,
        zOrder: Int = 0
    ) -> CgWindowRecord {
        CgWindowRecord(
            windowId: windowId,
            ownerPid: pid,
            ownerName: "App\(pid)",
            title: title,
            bounds: bounds,
            layer: layer,
            isOnScreen: isOnScreen,
            zOrder: zOrder
        )
    }

    static func axRecord(
        pid: pid_t,
        cgWindowId: CGWindowID?,
        title: String?,
        bounds: CGRect? = defaultBounds,
        isMinimized: Bool = false,
        indexInApplication: Int = 0
    ) -> AxWindowRecord {
        AxWindowRecord(
            ownerPid: pid,
            cgWindowId: cgWindowId,
            title: title,
            bounds: bounds,
            isMinimized: isMinimized,
            indexInApplication: indexInApplication
        )
    }
}
