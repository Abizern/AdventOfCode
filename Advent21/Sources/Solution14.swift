import AdventUtilities
import Algorithms
import Foundation

public enum Solution14: Solution {
    public static var title = "--- Day 14: Extended Polymerization ---"

    public static func part1(_ input: String) -> String {
        String(describing: run(input, iterations: 10))
    }

    public static func part2(_ input: String) -> String {
        String(describing: run(input, iterations: 40))
    }
}

extension Solution14 {
    static func parse(_ input: String) -> ([String: Int], [String: Character], Character) {
        let parts = input.newlines
        let template = parts[0]
        let lastChar = template.last!
        let mapping = parts[1].lines.map { line -> (String, Character) in
            let pair = String(line.prefix(2))
            let insert = line.last!
            return (pair, insert)
        }.reduce(into: [String: Character]()) { dict, element in
            dict[element.0] = element.1
        }

        let pairs = template.windows(ofCount: 2).reduce(into: [String: Int]()) { dict, pair in
            dict[String(pair), default: 0] += 1
        }

        return(pairs, mapping, lastChar)
    }

    static func runSubstitution(_ mapping: [String: Character], over: inout [String: Int], iterations: Int) {
        var pairs = over
        (0 ..< iterations).forEach { _ in
            var dict = [String: Int]()
            for pair in pairs {
                let key = pair.key
                let value = pair.value

                guard let insertion = mapping[key],
                      let first = key.first,
                      let last = key.last
                else {
                    dict[key, default: 0] += value
                    continue
                }
                let p1 = "\(first)\(insertion)"
                let p2 = "\(insertion)\(last)"
                dict[p1, default: 0] += value
                dict[p2, default: 0] += value
            }
            pairs = dict
        }
        over = pairs
    }

    static func run(_ input: String, iterations: Int) -> Int {
        let (pairs, mapping, lastChar) = parse(input)
        var mutablePairs = pairs
        var characterCount = [lastChar: 1]

        runSubstitution(mapping, over: &mutablePairs, iterations: iterations)

        mutablePairs.forEach { element in
            guard let k = element.key.first else { fatalError("Empty Key") }
            let v = element.value

            characterCount[k, default: 0] += v
        }

        return (characterCount.values.max() ?? 0) - (characterCount.values.min() ?? 0)
    }
}
