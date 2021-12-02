import AdventUtilities
import Advent21
import ArgumentParser
import Foundation

struct Select: ParsableCommand {
    enum Error: LocalizedError {
        case incorrectYear
        case incorrectDay
        case incorrectPart
    }

    @Option(name: .shortAndLong, help: "The year to run, The default is 21")
    var year: Int = 21

    @Option(name: .shortAndLong, help: "The day to run in 1 - 25. The default is 1")
    var day: Int = 1

    @Option(name: .shortAndLong, help: "The part to run, 1 or 2. Leave blank to run both parts")
    var part: Int = 0

    @Flag(name: .shortAndLong, help: "Runs all days and parts for the year. Ignores day and part options")
    var all = false

    func validate() throws {
        guard year == 21 else { throw Error.incorrectYear }
        guard (1..<26).contains(day) else { throw Error.incorrectDay }
        guard [0, 1, 2].contains(part) else { throw Error.incorrectPart }
    }

    func run() throws {
        let result = SolutionRunner.run(year: year, day: day, part: part, flag: all)
        print(result)
    }
}

extension Select.Error {
    var errorDescription: String? {
        switch self {
        case .incorrectYear:
            return "Please enter only the valid year '21', The default is '21'"
        case .incorrectDay:
            return "Please enter only the advent days 1 - 25"
        case .incorrectPart:
            return "There are only parts 1 and 2"
        }
    }
}

Select.main()
