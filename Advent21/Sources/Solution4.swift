import AdventUtilities
import Algorithms
import Foundation

public enum Solution4: Solution {
    public static var title = "--- Day 4: Giant Squid ---"

    public static func part1(_ input: String) -> String {
        let lines = input.newlines
        var game = parseGame(lines)
        let score = game.winningScore()

        return String(describing: score)
    }

    public static func part2(_ input: String) -> String {
        let lines = input.newlines
        var game = parseGame(lines)
        let score = game.lastWinningScore()

        return String(describing: score)
    }
}

extension Solution4 {
    static func parseGame(_ input: [String]) -> Game {
        Game(callSequence: parseCallSequence(input.first ?? ""), boards: parseBoards(Array(input.dropFirst())))
    }
    static func parseCallSequence(_ line: String) -> [Int] {
        line.components(separatedBy: ",").compactMap(Int.init)
    }

    static func parseBoards(_ lines: [String]) -> [Board] {
        lines
            .map { $0
            .components(separatedBy: .whitespacesAndNewlines)
                .compactMap(Int.init) }
            .map(Board.init)
    }
}

struct Board: Equatable {
    var numbers: [Int]

    init(_ numbers: [Int]) {
        self.numbers = numbers
    }

    mutating func dab(number: Int) -> Board {
        numbers.firstIndex(of: number).map { numbers[$0] = -1 }
        return self
    }

    var hasWon: Bool {
        let length = 5
        let check = [-1, -1, -1, -1, -1]
        var flag = false
        var cursor = 0

        while !flag && cursor < length {
            let subRange = (0 ..< 5)
            let row = subRange.map { numbers[cursor*5 + $0] }
            let column = (0 ..< 5).map { numbers[cursor + $0*5] }

            if row == check || column == check {
                flag = true
            }
            cursor += 1
        }

        return flag
    }

    var sumOfUncalledNumbers: Int {
        numbers.filter { $0 != -1 }.reduce(0, +)
    }
}

extension Board: CustomDebugStringConvertible {
    var debugDescription: String {
        String(describing: numbers)
    }


}

struct Game {
    var callSequence: [Int]
    var boards: [Board]
    var wonBoards: [(Int, Board)] = .init()

    mutating func call(number: Int) {
        boards = boards.map { board in
            var b = board
            return b.dab(number: number)
        }
    }

    var winningBoard: Board? {
        boards.first(where: \.hasWon)
    }

    mutating func winningScore() -> Int {
        let maxNumberOfCalls = callSequence.count
        var cursor = 0
        var score: Int? = nil


        while cursor < maxNumberOfCalls && score == nil {
            let number = callSequence[cursor]
            call(number: number)
            score = winningBoard.map { $0.sumOfUncalledNumbers * number }
            cursor += 1
        }

        return score ?? 0
    }

    mutating func lastWinningScore() -> Int {
        for number in callSequence {
            call(number: number)
            let won = boards.filter(\.hasWon).map { (number, $0) }
            wonBoards.append(contentsOf: won)
            boards = boards.filter { !$0.hasWon }

        }

        guard let (call, board) = wonBoards.last else { return 0 }
        return board.sumOfUncalledNumbers * call
    }
}
