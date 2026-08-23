import Foundation

package enum SessionsCopy {
    package static func standing(_ standing: SessionStanding) -> String {
        NSLocalizedString(key(of: standing), bundle: .main, comment: "")
    }

    private static func key(of standing: SessionStanding) -> String {
        switch standing {
        case .busy: "sessions.standing.busy"
        case .shell: "sessions.standing.shell"
        case .idle: "sessions.standing.idle"
        case .waiting: "sessions.standing.waiting"
        }
    }
}
