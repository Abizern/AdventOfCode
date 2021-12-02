import AdventUtilities
import Foundation

public enum Solution1: Solution {
    public static var title = "--- Day 1: Sonar Sweep ---"

    private static func countIncreasingWindows(_ input: [Int], width: Int) -> Int {
        zip(input, input.dropFirst(width))
            .filter { $0.0 < $0.1 }
            .count
    }

    public static func part1(_ input: String) -> String {
        return String(describing: countIncreasingWindows(input.ints, width: 1))
    }

    public static func part2(_ input: String) -> String {
        return String(describing: countIncreasingWindows(input.ints, width: 3))
    }
}
