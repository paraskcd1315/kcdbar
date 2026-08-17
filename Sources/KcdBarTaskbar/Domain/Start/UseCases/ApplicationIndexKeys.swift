/** Every band a letter index offers, whether or not anything is installed under it. */
package enum ApplicationIndexKeys {
    package static var all: [String] {
        [StartMenuMetrics.otherSectionKey] + letters
    }

    package static var letters: [String] {
        (UInt8(ascii: "A")...UInt8(ascii: "Z")).map { String(UnicodeScalar($0)) }
    }
}
