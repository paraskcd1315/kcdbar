import AppKit
import Foundation

/** Reads per-process energy impact from top, attributed to the applications a person can see. */
enum TopEnergySampler {
    static func sample() async -> [EnergyUser] {
        let applications = NSWorkspace.shared.runningApplications.filter { $0.activationPolicy == .regular }
        let namesByPid = Dictionary(
            uniqueKeysWithValues: applications.compactMap { application in
                application.localizedName.map { (application.processIdentifier, $0) }
            }
        )
        guard let output = await run() else { return [] }

        var totals: [String: Double] = [:]
        for line in output.split(separator: "\n") {
            guard let row = parse(String(line)),
                  let name = namesByPid[row.pid] ?? owner(of: row.command, among: Set(namesByPid.values))
            else {
                continue
            }
            totals[name, default: 0] += row.impact
        }

        return totals.map { EnergyUser(name: $0.key, impact: $0.value) }
    }

    private static func parse(_ line: String) -> (pid: pid_t, command: String, impact: Double)? {
        let columns = line.split(separator: " ", omittingEmptySubsequences: true)
        let last = columns.count - 1
        guard columns.count >= EnergySamplerMetrics.minimumColumns,
              let pid = pid_t(columns[EnergySamplerMetrics.pidColumn]),
              let impact = Double(columns[last])
        else {
            return nil
        }
        let command = columns[EnergySamplerMetrics.firstCommandColumn..<last]

        return (pid, command.joined(separator: " "), impact)
    }

    private static func owner(of command: String, among names: Set<String>) -> String? {
        names.first { name in
            command.hasPrefix(name) || name.hasPrefix(command)
        }
    }

    private static func run() async -> String? {
        await withCheckedContinuation { continuation in
            let process = Process()
            process.executableURL = URL(fileURLWithPath: EnergySamplerMetrics.executablePath)
            process.arguments = EnergySamplerMetrics.arguments

            let pipe = Pipe()
            process.standardOutput = pipe
            process.standardError = FileHandle.nullDevice

            do {
                try process.run()
            } catch {
                continuation.resume(returning: nil)
                return
            }
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            process.waitUntilExit()

            continuation.resume(returning: String(data: data, encoding: .utf8))
        }
    }
}
