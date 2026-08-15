enum TaskbarNotice: Equatable {
    case accessibilityMissing
    case noWindows

    var symbolName: String {
        switch self {
        case .accessibilityMissing: "lock.trianglebadge.exclamationmark"
        case .noWindows: "macwindow"
        }
    }

    var messageKey: String {
        switch self {
        case .accessibilityMissing: "taskbar.notice.accessibility"
        case .noWindows: "taskbar.notice.empty"
        }
    }

    var actionKey: String {
        "taskbar.notice.grant"
    }

    var isActionable: Bool {
        self == .accessibilityMissing
    }
}
