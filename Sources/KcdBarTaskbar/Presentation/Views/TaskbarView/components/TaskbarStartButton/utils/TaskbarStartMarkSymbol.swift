package enum TaskbarStartMarkSymbol {
    package static func name(for mark: BarStartMark) -> String {
        switch mark {
        case .bars: "line.3.horizontal"
        case .apple: "apple.logo"
        case .grid: "square.grid.2x2.fill"
        case .power: "power"
        case .windows11, .windows10: "square.grid.2x2.fill"
        }
    }
}
