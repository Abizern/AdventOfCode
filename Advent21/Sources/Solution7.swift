import AdventUtilities
import Foundation

// Completely brute force and inelegant, but it's early and I'm tired.
// It still runs fast enough...
public enum Solution7: Solution {
    public static var title = "--- Day 7: The Treachery of Whales ---"

    public static func part1(_ input: String) -> String {
        let cheapest = cheapestChange(in: input.intsFromLine, costFunction: simpleCost)
        return "\(cheapest)"
    }

    public static func part2(_ input: String) -> String {
        let cheapest = cheapestChange(in: input.intsFromLine, costFunction: complexCost)
        return "\(cheapest)"
    }
}

extension Solution7 {
    static func simpleCost(change: Int) -> Int {
        change
    }

    static func complexCost(change: Int) -> Int {
        change * (change + 1) / 2 // Euler
    }

    static func cheapestChange(in input: [Int], costFunction: (Int) -> Int) -> Int {
        let maxInput = input.max() ?? 0
        var cheapest = Int.max
        (0 ..< maxInput).forEach { target in
            var cost = 0
            for input in input {
                cost += costFunction(abs(input - target))
            }
            if cost < cheapest {
                cheapest = cost
            }
        }
        return cheapest
    }
}
