import Foundation

/** Reads per-process energy impact from top, aggregating an application's helpers into it. */
enum TopEnergySampler {
    static func sample() async -> [EnergyUser] {
        guard let output = await run() else { return [] }

        var totals: [String: Double] = [:]
        for line in output.split(separator: "\n") {
            guard let row = parse(String(line)) else { continue }
            totals[row.name, default: 0] += row.impact
        }

        return totals.map { EnergyUser(name: $0.key, impact: $0.value) }
    }

    private static func parse(_ line: String) -> (name: String, impact: Double)? {
        let columns = line.split(separator: " ", omittingEmptySubsequences: true)
        guard columns.count >= 3, Int(columns[0]) != nil, let impact = Double(columns[columns.count - 1])
        else {
            return nil
        }
        let command = columns[1..<(columns.count - 1)].joined(separator: " ")

        return (application(of: command), impact)
    }

    private static func application(of command: String) -> String {
        guard let range = command.range(of: " He") ?? command.range(of: " Helper") else { return command }

        return String(command[command.startIndex..<range.lowerBound])
    }

    private static func run() async -> String? {
        await withCheckedContinuation { continuation in
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/top")
            process.arguments = ["-l", "2", "-o", "power", "-stats", "pid,command,power", "-n", "12"]

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
