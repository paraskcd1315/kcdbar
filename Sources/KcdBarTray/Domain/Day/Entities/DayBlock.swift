/** One entry placed on the day's grid, in fractions of that day, sharing its width with what overlaps it. */
package struct DayBlock: Equatable, Sendable, Identifiable {
    package let entry: DayEntry
    package let top: Double
    package let height: Double
    package let column: Int
    package let columns: Int

    package var id: Int { entry.id }

    package init(entry: DayEntry, top: Double, height: Double, column: Int, columns: Int) {
        self.entry = entry
        self.top = top
        self.height = height
        self.column = column
        self.columns = columns
    }
}
