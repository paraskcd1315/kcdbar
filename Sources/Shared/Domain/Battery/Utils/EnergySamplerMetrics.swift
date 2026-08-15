/** How the energy readout is sampled from the system's own reporter. */
enum EnergySamplerMetrics {
    static let executablePath = "/usr/bin/top"
    static let arguments = ["-l", "2", "-o", "power", "-stats", "pid,command,power", "-n", "20"]
    static let minimumColumns = 3
    static let pidColumn = 0
    static let firstCommandColumn = 1
}
