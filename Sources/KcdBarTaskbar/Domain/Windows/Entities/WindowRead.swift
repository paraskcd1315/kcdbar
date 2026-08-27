/** One pass over CoreGraphics and Accessibility, taken off the main actor and applied on it. */
package struct WindowRead: Sendable {
    package let coreGraphics: [CgWindowRecord]
    package let accessibility: AxWindowScan

    package init(coreGraphics: [CgWindowRecord], accessibility: AxWindowScan) {
        self.coreGraphics = coreGraphics
        self.accessibility = accessibility
    }
}
