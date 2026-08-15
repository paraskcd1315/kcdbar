/** How the energy readout is sampled from the system's own reporter. */
package enum EnergySamplerMetrics {
    package static let executablePath = "/usr/bin/top"
    package static let arguments = ["-l", "2", "-o", "power", "-stats", "pid,command,power", "-n", "20"]
    package static let minimumColumns = 3
    package static let pidColumn = 0
    package static let firstCommandColumn = 1
}
