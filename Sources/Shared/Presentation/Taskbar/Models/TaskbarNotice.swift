enum TaskbarNotice: Equatable {
    case accessibilityMissing

    var symbolName: String {
        "lock.trianglebadge.exclamationmark"
    }

    var messageKey: String {
        "taskbar.notice.accessibility"
    }

    var actionKey: String {
        "taskbar.notice.grant"
    }
}
