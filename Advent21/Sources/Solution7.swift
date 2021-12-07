import AdventUtilities
import Foundation

// Completely brute force and inelegant, but it's early and I'm tired.
// It still runs fast enough...
public enum Solution7: Solution {
    public static var title = "--- Day 7: The Treachery of Whales ---"

    public static func part1(_ input: String) -> String {
        String(describing: cheapestChange(in: input.intsFromLine, costFunction: simpleCost))
    }

    public static func part2(_ input: String) -> String {
        String(describing: cheapestChange(in: input.intsFromLine, costFunction: complexCost))
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
        func accumulator(current accum: inout Int, change: Int) {
            accum += costFunction(change)
        }
        let maxInput = input.max() ?? 0
        var cheapest = Int.max
        (0 ..< maxInput).forEach { target in
            let cost = input
                .map { abs($0 - target) }
                .reduce(into: 0, accumulator)

            if cost < cheapest {
                cheapest = cost
            }
        }
        return cheapest
    }
}
