import AdventUtilities
import Foundation

public enum Solution11: Solution {
    public static var title = "--- Day 11: Dumbo Octopus ---"

    public static func part1(_ input: String) -> String {
        var grid = parseInput(input)
//        print("Initial:\n\(grid)")
        var count = 0
        (0 ..< 100).forEach { n in
            count += grid.cycleAndCount()
//            print("Step \(n):\n\(grid)")
        }

        return String(describing: count)
    }

    public static func part2(_ input: String) -> String {
        var grid = parseInput(input)
        var iteration = 0
        var flashCount = 0
        while flashCount < 100  && iteration < 1000 {
            flashCount = grid.cycleAndCount()
            iteration += 1
        }
        return ("\(iteration)")
    }
}

extension Solution11 {
    static func parseInput(_ input: String) -> Grid {
        Grid(input
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lines
            .compactMap { $0.compactMap(\.wholeNumberValue).map(DumboState.init) })
    }
}

extension Solution11 {
    enum DumboState: Equatable {
        case normal(Int)
        case ready
        case flashed

        init(_ n: Int) {
            self = .normal(n)
        }

        var incremented: DumboState {
            switch self {
            case .normal(let n) where n < 9:
                return .normal(n + 1)
            case .normal(let n) where n == 9:
                return .ready
            default:
                return self
            }
        }
    }
}

extension Solution11 {
    struct Grid {
        struct Position: Hashable {
            let r: Int
            let c: Int
        }

        private var dict: [Position: DumboState]
        private let adjacencyList: [Position: [Position]]
        let width: Int
        let height: Int

        init(_ positions: [[DumboState]]) {
            width = positions.first?.count ?? 0
            height = positions.count

            var d = [Position: DumboState]()
            var a = [Position: [Position]]()
            for (j, row) in positions.enumerated() {
                for (i, value) in row.enumerated() {
                    let pos = Position(r: j, c: i)
                    d[pos] = value
                    a[pos] = Self.adjacentPositions(pos, width: width, height: height)
                }
            }
            dict = d
            adjacencyList = a
        }

        static func adjacentPositions(_ pos: Position, width: Int, height: Int) -> [Position] {
            let rowRange = (0 ..< height)
            let colRange = (0 ..< width)
            let changes = [-1, 0, 1]
            var positions = [Position]()
            changes.forEach { dr in
                changes.forEach { dc in
                    let r = pos.r + dr
                    let c = pos.c + dc
//                    print("\(dr) \(dc) \(r) \(c)")
                    let newPos = Position(r: r, c: c)
                    if rowRange.contains(r) && colRange.contains(c) && newPos != pos {
                        positions.append(newPos)
                    }
                }
            }
//            print("Adjacent of: \(pos) -> \(positions)")
            return positions
        }

        mutating func incrementAll() {
            for key in dict.keys {
                increment(key)
            }
        }

        mutating func increment(_ position: Position) {
            dict[position].map { dict[position] = $0.incremented }
        }

        mutating func reset(_ position: Position) {
            dict[position] = .normal(0)
        }

        mutating func flash(_ position: Position) {
            dict[position] = .flashed
            adjacencyList[position].map { neighbours in
                for neighbour in neighbours {
                    increment(neighbour)
                }
            }
        }

        mutating func runAllFlashes() {
            var readyStateDumbo = dict.filter { $0.1 == .ready }.keys
            while !readyStateDumbo.isEmpty {
                for pos in readyStateDumbo {
                    flash(pos)
                }
                readyStateDumbo = dict.filter { $0.1 == .ready }.keys
//                print("Flashed:\n\(self)")
            }
        }

        mutating func countAndReset() -> Int {
            let positions = dict.filter { $0.1 == .flashed }.keys
            for position in positions {
                reset(position)
            }

            return positions.count
        }

        mutating func cycleAndCount() -> Int {
            incrementAll()
//            print("Incremented:\n\(self)")
            runAllFlashes()
            return countAndReset()
        }
    }
}

extension Solution11.DumboState: CustomStringConvertible {
    var description: String {
        switch self {
        case .normal(let n):
            return "\(n)"
        case.ready:
            return "R"
        case .flashed:
            return "F"
        }
    }


}

extension Solution11.Grid: CustomStringConvertible {
    var description: String {
        var string = ""
        (0 ..< height).forEach { row in
            var line = ""
            (0 ..< width).forEach { column in
                let pos = Position(r: row, c: column)
                let description = dict[pos].map { String(describing: $0) } ?? "X"
                line.append(description)
            }
            line.append("\n")
            string.append(line)
        }

        return string
    }
}
