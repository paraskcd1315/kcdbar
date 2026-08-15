@MainActor
package protocol WindowChangeObserverPort: AnyObject {
    func startObserving(onChange: @escaping () -> Void)
    func stopObserving()
}
