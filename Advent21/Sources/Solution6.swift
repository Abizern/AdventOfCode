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
                    .safeString
                    .components(separatedBy: ",")
                    .compactMap(Int.init)
                    .map { ($0, 1) },
                   uniquingKeysWith: +)
    }
    static func countPopulation(of input: [Int: Int], over: Int) -> Int {
        var memo = input

        (0..<over).forEach { _ in
            var temp = [Int: Int]()
            memo.forEach { (key, value) in
                if key == 0 {
                    temp[6, default: 0] += value
                    temp[8, default: 0] += value
                } else {
                    temp[key - 1, default: 0] += value
                }
            }

            memo = temp
        }

        return memo.values.reduce(0, +)
    }
}
