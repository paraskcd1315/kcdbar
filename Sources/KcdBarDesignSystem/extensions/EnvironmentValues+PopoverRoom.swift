import SwiftUI

package extension EnvironmentValues {
    var popoverRoom: CGFloat {
        get { self[PopoverRoomKey.self] }
        set { self[PopoverRoomKey.self] = newValue }
    }
}
