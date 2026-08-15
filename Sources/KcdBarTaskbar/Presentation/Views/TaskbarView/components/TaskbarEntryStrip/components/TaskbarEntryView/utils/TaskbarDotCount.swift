/** The first dot says the process is running; every dot after it is one open window. */
package enum TaskbarDotCount {
    package static func dots(windows: Int) -> Int {
        guard windows > 0 else { return 0 }

        return windows + 1
    }
}
