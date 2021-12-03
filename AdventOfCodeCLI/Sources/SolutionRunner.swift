import Advent21
import AdventUtilities
import Foundation
import Inputs

enum SolutionRunner {
    enum Part: Int {
        case all = 0
        case first = 1
        case second = 2
    }

    static func run(year: Int, day: Int, part: Int, flag: Bool) -> String {
        guard let year = CLI.Year(rawValue: "\(year)"),
              let day = CLI.Problem(rawValue: day),
              let part = Part(rawValue: part)
        else {
            return "Incorrect input year: \(year) or day: \(day)"
        }

        return flag ? runAllSolution(year) : run (year: year, day: day, part: part)
    }

    private static func runAllSolution(_ year: CLI.Year) -> String {
        year.year.title + "\n" + 
        zip((1...), year.year.solutions)
            .compactMap { (dayIndex, solution) -> String? in
                guard
                    let problem = CLI.Problem(rawValue: dayIndex),
                    let input = try? input(year: year, problem: problem)
                else { return nil }

                let part1 = "Part1: " + solution.part1(input)
                let part2 = "Part2: " + solution.part2(input)

                return [solution.title, part1, part2].joined(separator: "\n")
            }
            .joined(separator: "\n")
    }

    private static func run(year: CLI.Year, day: CLI.Problem, part: Part = .all) -> String {
        let solutions = year.year.solutions
        guard
            let index = CLI.Problem.allCases.firstIndex(of: day),
            let input = try? input(year: year, problem: day),
            index < solutions.count
        else {
            return "That day has not been implemented"
        }

        let solution = solutions[index]
        var part1: String?
        var part2: String?

        switch part {
        case .all:
            part1 = "Part 1: " + solution.part1(input)
            part2 = "Part 2: " + solution.part2(input)
        case .first:
            part1 = "Part 1: " + solution.part1(input)
        case .second:
            part1 = "Part 2: " + solution.part2(input)
        }

        return [year.year.title, solution.title, part1, part2]
            .compactMap { $0 }
            .joined(separator: "\n")
    }
}


extension CLI.Year {
    var year: AdventUtilities.Year.Type {
        switch self {
        case .y21:
            return Year2021.self
        }
    }
}
