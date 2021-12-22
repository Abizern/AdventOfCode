import AdventUtilities
import Collections
import Foundation
import Parsing

public enum Solution22: Solution {
    public static var title = "--- Day 22: Reactor Reboot ---"

    public static func part1(_ input: String) -> String {
        let instructions = parse(input)
        let cubeRange = (-50 ... 50)

        var count = 0
        cubeRange.forEach { x in
            cubeRange.forEach { y in
                cubeRange.forEach { z in
                    var cube = (x, y, z, 0)
                    for instruction in instructions {
                        instruction(&cube)
                    }
                    if cube.3 == 1 {
                        count += 1
                    }
                }
            }
        }

        return "\(count)"
    }

    public static func part2(_ input: String) -> String {
        "Not Solved Yet"
    }
}

private extension Solution22 {
    enum State: Equatable {
        case on
        case off

        init(_ str: Substring) {
            if str == "on" {
                self = .on
            } else {
                self = .off
            }
        }
    }

    static func makeInstruction(_ values: (Substring, (Int, Int), (Int, Int), (Int, Int))) -> (inout (Int, Int, Int, Int)) -> Void {
        let instruction: String = String(values.0)
        let xRange = values.1
        let yRange = values.2
        let zRange = values.3

        return { cube in
            let (x, y, z, _) = cube
            if (xRange.0 ... xRange.1).contains(x) && (yRange.0 ... yRange.1).contains(y) && (zRange.0 ... zRange.1).contains(z) {
                if instruction == "on" {
                    cube = (x, y, z, 1)
                } else {
                    cube = (x, y, z, 0)
                }
            }
        }
    }

    // on x=10..12,y=10..12,z=10..12
    static func parse(_ input: String) -> [(inout (Int, Int, Int, Int)) -> Void] {
        var string = input[...]
        let rangeParser = Int.parser().skip("..").take(Int.parser())
        let instructionParser = PrefixUpTo(" ")
            .skip(" x=")
            .take(rangeParser)
            .skip(",y=")
            .take(rangeParser)
            .skip(",z=")
            .take(rangeParser)
            .map(makeInstruction)

        return Many(instructionParser, separator: "\n").parse(&string) ?? []
    }
}
