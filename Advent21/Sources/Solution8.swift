import AdventUtilities
import Foundation

public enum Solution8: Solution {
    public static var title = "--- Day 8: Seven Segment Search ---"

    public static func part1(_ input: String) -> String {
        String(describing: input
                .lines
                .map(parseLine)
                .map(\.countOfKnownNumbers)
                .reduce(0, +))
    }

    public static func part2(_ input: String) -> String {
        String(describing: input
                .lines
                .map(parseLine)
                .map(\.reading)
                .reduce(0, +))
    }
}

extension Solution8 {
    struct Input: Equatable {
        var options: [Set<Character>]
        var numbers: [Set<Character>]

        var countOfKnownNumbers: Int {
            let knownLengths = [2, 3, 4, 7]
            return numbers.filter { knownLengths.contains($0.count) }.count
        }

        var reading: Int {
            let dict = mappingDictionary
            return numbers
                .map { number in
                    dict[number] ?? 0
                }
                .reduce(0) { partialResult, digit in
                    partialResult * 10 + digit
                }
        }

        var mappingDictionary: [Set<Character>: Int] {
            let d1 = options.first { $0.count == 2 }!
            let d4 = options.first { $0.count == 4 }!
            let d7 = options.first { $0.count == 3 }!
            let d8 = options.first { $0.count == 7 }!

            var parts5 = options.filter { $0.count == 5 }
            var parts6 = options.filter { $0.count == 6 }

            let d6 = parts6.first { candidate in
                candidate.intersection(d1).count == 1
            }!

            parts6 = parts6.filter { $0 != d6 }

            let d9 = parts6.first { candidate in
                candidate.intersection(d4).count == 4
            }!

            parts6 = parts6.filter { $0 != d9 }

            let d0 = parts6.first { candidate in
                candidate != d6 && candidate != d9
            }!


            let d3 = parts5.first { candidate in
                candidate.intersection(d7).count == 3
            }!

            parts5 = parts5.filter { $0 != d3 }


            let d2 = parts5.first { candidate in
                candidate.intersection(d8.subtracting(d6)).count == 1
            }!

            parts5 = parts5.filter { $0 != d2 }

            let d5 = parts5.first { candidate in
                candidate != d2 && candidate != d3
            }!

            return [
                d0 : 0,
                d1 : 1,
                d2 : 2,
                d3 : 3,
                d4 : 4,
                d5 : 5,
                d6 : 6,
                d7 : 7,
                d8 : 8,
                d9 : 9
            ]
        }
    }

    static func parseLine(_ string: String) -> Input {
        let split = string.components(separatedBy: .whitespaces).filter { $0 != "|"}.map(Set.init)
        return Input(options: Array(split[0..<10]), numbers: Array(split[10...]))
    }
}
