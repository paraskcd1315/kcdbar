protocol CgWindowSourceProviding: Sendable {
    func currentWindows() -> [CgWindowRecord]
}
