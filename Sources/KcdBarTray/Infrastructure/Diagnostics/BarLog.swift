import OSLog

package enum BarLog {
    package static let subsystem = "com.paraskcd.kcdbar"

    package static let bar = Logger(subsystem: subsystem, category: "bar")
}
