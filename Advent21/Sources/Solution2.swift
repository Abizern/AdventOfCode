import AdventUtilities
import Foundation
import Parsing

public enum Solution2: Solution {
    public static var title = "--- Day 2: Dive! ---"

    public static func part1(_ input: String) -> String {
        String(parseInput(input).reduce(into: Position(), simpleNavigation).result)
    }

    public static func part2(_ input: String) -> String {
        String(parseInput(input).reduce(into: Position(), complexNavigation).result)
    }
}

extension Solution2 {
    enum Instruction: Equatable {
        case forward(Int)
        case up(Int)
        case down(Int)

        init?(_ direction: Substring, _ value: Int) {
            switch (direction.first, value) {
            case let (s?, n) where s == "f":
                self = .forward(n)
            case let (s?, n) where s == "u":
                self = .up(n)
            case let (s?, n) where s == "d":
                self = .down(n)
            default:
                return nil
            }
        }
    }

    static func parseInput(_ input: String) -> [Instruction] {
        let instruction = PrefixUpTo(" ")
            .skip(" ")
            .take(Int.parser())
            .compactMap(Instruction.init)

        return Many(instruction, separator: "\n").parse(input) ?? []

    }

    static func simpleNavigation(_ position: inout Position, _ instruction: Instruction) {
        switch instruction {
        case .forward(let int):
            position.x += int
        case .up(let int):
            position.y -= int
        case .down(let int):
            position.y += int
        }
    }

    static func complexNavigation(_ position: inout Position, _ instruction: Instruction) {
        switch instruction {
        case .forward(let int):
            position.x += int
            position.y += (int * position.aim)
        case .up(let int):
            position.aim -= int
        case .down(let int):
            position.aim += int
        }
    }

    struct Position {
        var x = 0
        var y = 0
        var aim = 0
    }
}

extension Solution2.Position {
    var result: Int { x * y }
}
