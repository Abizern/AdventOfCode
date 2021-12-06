import AdventUtilities
import Foundation

public enum Solution6: Solution {
    public static var title = "--- Day 6: Lanternfish ---"

    public static func part1(_ input: String) -> String {
        let inputDictionary = generateDictionary(input)

        return "\(countPopulation(of: inputDictionary, over: 80))"
    }

    public static func part2(_ input: String) -> String {
        let inputDictionary = generateDictionary(input)

        return "\(countPopulation(of: inputDictionary, over: 256))"
    }
}

extension Solution6 {
    static func generateDictionary(_ input: String) -> [Int: Int] {
        Dictionary(input
                    .intsFromLine
                    .map { ($0, 1) },
                   uniquingKeysWith: +)
    }
    static func countPopulation(of input: [Int: Int], over: Int) -> Int {
        (0 ..< over).reduce(into: input) { start, _ in
            var end = [Int: Int]()
            start.forEach { key, value in
                if key == 0 {
                    end[6, default: 0] += value
                    end[8] = value
                } else {
                    end[key - 1, default: 0] += value
                }
            }
            start = end
        }
        .values
        .reduce(0, +)
    }
}
