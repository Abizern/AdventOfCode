import AdventUtilities
import Foundation
import Parsing

public enum Solution20: Solution {
    public static var title = "--- Day 20: Trench Map ---"

    public static func part1(_ input: String) -> String {
        let (rule, bits) = parse(input)
        var trenchMap = TrenchMap(rule: rule, bits: bits)

        (0 ..< 2).forEach { n in
            trenchMap.process(evenStep: n % 2 == 0)
        }

        return "\(trenchMap.trackedPoints)"
    }

    public static func part2(_ input: String) -> String {
        let (rule, bits) = parse(input)
        var trenchMap = TrenchMap(rule: rule, bits: bits)

        (0 ..< 50).forEach { n in
            trenchMap.process(evenStep: n % 2 == 0)
        }

        return "\(trenchMap.trackedPoints)"
    }
}

extension Solution20 {
    struct TrenchMap {
        private struct Position: Hashable, CustomStringConvertible {
            var description: String {
                "(\(r), \(c))"
            }

            let r: Int
            let c: Int
        }

        private var rule: [Int]
        private var points: Set<Position> = .init()
        private let offset: Int = 3

        init(rule: [Int], bits: [[Int]]) {
            let height = bits.count
            let width = bits[0].count

            var points = Set<Position>()

            (0 ..< height).forEach { row in
                (0 ..< width).forEach { col in
                    if bits[row][col] == 1 {
                        points.insert(Position(r: row, c: col))
                    }
                }
            }
            self.rule = rule
            self.points = points
        }

        private func isTracked(_ position: Position) -> Bool {
            points.contains(position)
        }

        private func ruleIndex(_ position: Position, evenStep: Bool) -> Int {
            var windowValues: [Int] = .init()

            (position.r - 1 ... position.r + 1).forEach { row in
                (position.c - 1 ... position.c + 1).forEach { col in
                    let position = Position(r: row, c: col)
                    switch (isTracked(position), evenStep) {
                    case (true, true):
                        windowValues.append(1)
                    case (true, false):
                        windowValues.append(0)
                    case (false, true):
                        windowValues.append(0)
                    case (false, false):
                        windowValues.append(1)
                    }
                }
            }

            return windowValues.reduce(into: 0) { binary, digit in
                binary = binary * 2 + digit
            }
        }

        private func shouldTrack(_ position: Position, evenStep: Bool) -> Bool {
            switch (rule[ruleIndex(position, evenStep: evenStep)], evenStep) {
            case (1, true):
                return false // track off states for even steps (this is how we deal with an infinite plane of values, and why tests don't work
            case (0, true):
                return true
            case (1, false):
                return true
            case(0, false):
                return false
            default:
                return false
            }
        }

        mutating func process(evenStep: Bool) {
            let rValues = points.map(\.r)
            let cValues = points.map(\.c)
            let rMin = rValues.min() ?? 0
            let rMax = rValues.max() ?? 0
            let cMin = cValues.min() ?? 0
            let cMax = cValues.max() ?? 0

            var newPoints: Set<Position> = .init()

            (rMin - offset ... rMax + offset).forEach { row in
                (cMin - offset ... cMax + offset).forEach { col in
                    let position = Position(r: row, c: col)
                    if shouldTrack(position, evenStep: evenStep) {
                        newPoints.insert(position)
                    }
                }
            }
            points = newPoints
        }

        var trackedPoints: Int {
            points.count
        }
    }
}

extension Solution20 {
    private static func parse(_ input: String) -> ([Int], [[Int]]) {
        var string = input[...]
        let ruleParser = PrefixUpTo("\n").skip("\n\n").map { $0.map { $0.toDigit } }
        let lineParser = PrefixUpTo("\n").map { $0.map { $0.toDigit } }
        guard
            let rule = ruleParser.parse(&string),
            let lines = (Many(lineParser, separator: "\n")).parse(&string)
        else {
            fatalError("Unable to parse input \(input)")
        }

        return (rule, lines)
    }
}

extension Character {
    fileprivate var toDigit: Int {
        switch self {
        case ".":
            return 0
        case "#":
            return 1
        default:
            return 0
        }
    }
}
