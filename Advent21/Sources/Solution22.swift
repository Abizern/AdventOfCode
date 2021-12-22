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
        let rawValues = parseRawValues(input)
        let (xValToIndex, xIndexToLength) = mapping(Set(rawValues.map(\.1).flatMap { [$0.0, $0.1 + 1] }))
        let (yValToIndex, yIndexToLength) = mapping(Set(rawValues.map(\.2).flatMap { [$0.0, $0.1 + 1] }))
        let (zValToIndex, zIndexToLength) = mapping(Set(rawValues.map(\.3).flatMap { [$0.0, $0.1 + 1] }))
        var reactor: Set<Cube> = .init()

        rawValues.forEach { (state, xs, ys, zs) in
            (xValToIndex[xs.0]! ..< xValToIndex[xs.1 + 1]!).forEach { x in
                (yValToIndex[ys.0]! ..< yValToIndex[ys.1 + 1]!).forEach { y in
                    (zValToIndex[zs.0]! ..< zValToIndex[zs.1 + 1]!).forEach { z in
                        let cube = Cube(x: x, y: y, z: z)
                        switch state {
                        case .on:
                            reactor.insert(cube)
                        default:
                            reactor.remove(cube)
                        }
                    }
                }
            }
        }

        let result = reactor.map { cube in
            xIndexToLength[cube.x]! * yIndexToLength[cube.y]! * zIndexToLength[cube.z]!
        }.reduce(0, +)



        return "\(result)"
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


// Part 2
private extension Solution22 {
    typealias RawValue = (State, (Int, Int), (Int, Int), (Int, Int))

    struct Cube: Hashable {
        let x: Int
        let y: Int
        let z: Int
    }

    static func parseRawValues(_ input: String) -> [RawValue] {
        var string = input[...]
        let rangeParser = Int.parser().skip("..").take(Int.parser())
        let instructionParser = PrefixUpTo(" ")
            .skip(" x=")
            .take(rangeParser)
            .skip(",y=")
            .take(rangeParser)
            .skip(",z=")
            .take(rangeParser)
            .map { parsed in
                (State(parsed.0), parsed.1, parsed.2, parsed.3)
            }

        guard let rawValues = Many(instructionParser, separator: "\n").parse(&string) else {
            fatalError("Can't parse input as expected")
        }

        return rawValues
    }

    static func mapping(_ values: Set<Int>) -> ([Int: Int], [Int: Int]) {
        let sortedValues = values.sorted()
        let numberOfValues = sortedValues.count
        var valueToIndex = [Int: Int]()
        var indexToLength = [Int: Int]()
        for (i, value) in sortedValues.enumerated() {
            valueToIndex[value] = i
            if i + 1 < numberOfValues {
                indexToLength[i] = sortedValues[i + 1] - value
            }
        }

        return (valueToIndex, indexToLength)
    }
}
