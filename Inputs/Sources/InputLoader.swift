import Foundation

/// Returns the raw input for the day.
public func input(year: CLI.Year, problem: CLI.Problem) throws -> String {
    let base = "Resources"
    let year = year.rawValue
    let problemNumber = problem.rawValue

    let path = "\(base)/\(year)/day\(String(format: "%02d", problemNumber))"

    guard let url = Bundle.module.url(forResource: path, withExtension: "txt")
    else {
        throw InputsError.fileNotFound(path)
    }

    return try String(contentsOf: url)
}
