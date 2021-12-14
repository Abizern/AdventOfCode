import AdventUtilities
import Algorithms
import Foundation

public enum Solution14: Solution {
    public static var title = "--- Day 14: Extended Polymerization ---"

    public static func part1(_ input: String) -> String {
        let (template, mapping) = parse(input)
        var s = template
        (0 ..< 10).forEach { n in
            s = apply(template: s, mapping: mapping)
        }
        let dict = Dictionary(s.map { ($0, 1) }, uniquingKeysWith: +).map { element in
            element.1
        }
        print(dict)
        let result = dict.max()! - dict.min()!

        return "\(result)"
    }

    public static func part2(_ input: String) -> String {
        let parsedInput = parse2(input)
        var pairs = parsedInput.0
        var characterCounter: [Character: Int] = [parsedInput.2: 1] // last character
        let mapping = parsedInput.1

        (0 ..< 40).forEach { _ in
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
        pairs.forEach { element in
            let k = element.key.first!
            let v = element.value

            characterCounter[k, default: 0] += v
        }


        let result = characterCounter.values.max()! - characterCounter.values.min()!


        return "\(result)"
    }
}

extension Solution14 {
    static func parse(_ input: String) -> (String, [String: Character]) {
        let parts = input.newlines
        let template = parts[0]
        let mapping = parts[1]
        let pairs = mapping.lines.map { line -> (String, Character) in
            let pair = String(line.prefix(2))
            let insert = line.last!
            return (pair, insert)
        }.reduce(into: [String: Character]()) { dict, element in
            dict[element.0] = element.1
        }

        return (template, pairs)
    }

    static func parse2(_ input: String) -> ([String: Int], [String: Character], Character) {
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

    static func apply(template: String, mapping: [String: Character]) -> String {
        let pairs = template.windows(ofCount: 2).map { substring -> String in
            let pair = String(substring)
            guard let insertion = mapping[pair],
                  let first = substring.first,
                  let last = substring.last
            else { return pair }

            return "\(first)\(insertion)\(last)"
        }

        let initial = pairs[0]
        let last = String(pairs.last!.dropFirst())
        let newPolymer = pairs.dropFirst().dropLast().reduce(into: initial) { polymer, pair in
            polymer += String(pair.dropFirst())
        } + last

        return newPolymer
    }

}
