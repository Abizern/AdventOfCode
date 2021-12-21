import AdventUtilities
import Collections
import Foundation
import Parsing

public enum Solution21: Solution {
    public static var title = "--- Day 21: Dirac Dice ---"

    public static func part1(_ input: String) -> String {
        let players = parse(input)
        let result = runGame(players: players)

        return "\(result)"
    }

    public static func part2(_ input: String) -> String {
        return "Not Solved Yet"
    }
}

extension Solution21 {
    private struct DeterministicDice: Sequence, IteratorProtocol {
        typealias Element = Int
        private (set) var index = 0

        mutating func next() -> Int? {
            let n = index + 3
            defer {
                index = n
            }
            return triangleSum(n) - triangleSum(n - 3)
        }

        private func triangleSum(_ n: Int) -> Int {
            (n * (n + 1)) / 2
        }
    }

    private struct GamePosition: Equatable {
        private var internalValue: Int

        init(position: Int) {
            guard position != 0 else {
                fatalError("Start position \(position) is not in [1...10]")
            }
            internalValue = position - 1
        }

        var value: Int {
            internalValue + 1
        }

        mutating func advanceBy(_ n: Int) {
            internalValue = (internalValue + n) % 10
        }
    }

    private struct Player: Equatable {
        private let name: String
        private var gamePosition: GamePosition
        var score: Int = 0

        init(name: String, position: Int) {
            self.name = name
            self.gamePosition = GamePosition(position: position)
        }

        var hasWon: Bool {
            score >= 1000
        }

        mutating func advanceBy(_ n: Int) {
            gamePosition.advanceBy(n)
            score += gamePosition.value
        }
    }

    private static func runGame(players: [Player]) -> Int {
        var playerQueue = Deque(players)
        var die = DeterministicDice()


        while !playerQueue.map(\.hasWon).contains(true) {
            guard var player = playerQueue.popFirst(),
                  let roll = die.next()
            else {
                fatalError("Incorrect state")
            }

            player.advanceBy(roll)
            playerQueue.append(player)
        }

        let losingScore = playerQueue.popFirst()?.score ?? 0
        let rollCount = die.index

        return losingScore * rollCount
    }
}


extension Solution21 {
    private static func parse(_ input: String) -> [Player] {
        var str = input[...]
        let playerParser = PrefixUpTo(" s")
            .skip(" starting position: ")
            .take(Int.parser()).map { (name, position) in
                Player(name: String(name), position: position)
            }

        return Many(playerParser, separator: "\n").parse(&str) ?? []
    }
}
