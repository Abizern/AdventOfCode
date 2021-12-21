import AdventUtilities
import Algorithms
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
        let players = parse(input).map(DiracPlayer.init)
        let result = runDiracGame(players: players)
        return "\(result)"
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

    private struct GamePosition: Hashable {
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
        private(set) var gamePosition: GamePosition
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
    private struct DiracPlayer: Hashable {
        private(set) var gamePosition: GamePosition
        private(set) var score: Int = 0

        init(_ player: Player) {
            self.gamePosition = player.gamePosition
        }

        var hasWon: Bool {
            score >= 21
        }

        mutating func advanceBy(_ n: Int) {
            gamePosition.advanceBy(n)
            score += gamePosition.value
        }
    }

    private struct GameState: Hashable {
        var p1: DiracPlayer
        var p2: DiracPlayer

        init(_ players: [DiracPlayer]) {
            p1 = players[0]
            p2 = players[1]
        }

        mutating func swap() {
            let t = p1
            p1 = p2
            p2 = t
        }

        var result: (Int, Int) {
            switch (p1.hasWon, p2.hasWon) {
            case (true, false):
                return (1, 0)
            case (false, true):
                return (0, 1)
            default:
                return (0, 0)
            }
        }
    }

    private static func runDiracGame(players: [DiracPlayer]) -> Int {
        var memo: [GameState: (Int, Int)] = .init()
        let diceRolls = diracDiceRolls()
        let gameState = GameState(players)


        func countWins(_ gameState: GameState) -> (Int, Int) {
            let stateResult = gameState.result
            guard stateResult == (0, 0) else {
                return stateResult
            }

            if let memoResult = memo[gameState] {
                return memoResult
            }

            // recursively work out the result
            var accumulator = (0, 0)
            for diceRoll in diceRolls {
                var worldState = gameState
                worldState.p1.advanceBy(diceRoll)
                worldState.swap()
                let (r0, r1) = countWins(worldState)
                accumulator = (accumulator.0 + r1, accumulator.1 + r0)
            }

            memo[gameState] = accumulator
            return accumulator
        }

        let result = countWins(gameState)
        return max(result.0, result.1)
    }

    private static func diracDiceRolls() -> [Int] {
        let range = (1 ... 3)
        var results: [Int] = .init()
        range.forEach { first in
            range.forEach { second in
                range.forEach { third in
                    results.append(first + second + third)
                }
            }
        }

        return results
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
