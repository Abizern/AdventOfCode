import AdventUtilities
import Foundation

public enum Solution3: Solution {
    public static var title = "--- Day 3: Binary Diagnostic ---"

    public static func part1(_ input: String) -> String {
        let lines = input.lines
        guard let first = lines.first else {
            return "Invalid input"
        }

        let partitionValue = partitionValue(first)
        let numbers = lines.compactMap { Int($0, radix: 2) }.sorted()

        return "\(gammaValue(numbers, partitionValue: partitionValue) * epsilonValue(numbers, partitionValue: partitionValue))"
    }

    public static func part2(_ input: String) -> String {
        let lines = input.lines
        guard let first = lines.first else {
            return "Invalid input"
        }

        let partitionValue = partitionValue(first)
        let numbers = lines.compactMap { Int($0, radix: 2) }

        return "\(oxygenRating(numbers, partitionValue: partitionValue) * co2Rating(numbers, partitionValue: partitionValue))"
    }
}

extension Solution3 {
    static func partitionValue(_ string: String) -> Int{
        1 << (string.count - 1)
    }

    static func gammaValue(_ numbers: [Int], partitionValue: Int) -> Int {
        partition(numbers, partitionValue: partitionValue, isUpper: true)
    }

    static func epsilonValue(_ numbers: [Int], partitionValue: Int) -> Int {
        partition(numbers, partitionValue: partitionValue, isUpper: false)
    }

    static func oxygenRating(_ numbers: [Int], partitionValue: Int) -> Int {
        consumingPartition(numbers, partitionValue: partitionValue, isUpper: true)
    }

    static func co2Rating(_ numbers: [Int], partitionValue: Int) -> Int {
        consumingPartition(numbers, partitionValue: partitionValue, isUpper: false)
    }

    static func partition(_ numbers: [Int], partitionValue: Int, isUpper: Bool) -> Int {
        var partition = partitionValue
        var accumulator = 0
        var inputs = numbers

        while partition > 0 {
            var low = [Int]()
            var high = [Int]()

            for input in inputs {
                if input < partition {
                    low.append(input)
                } else {
                    high.append(input)
                }
            }
            let shouldIncrement: Bool
            if isUpper {
                shouldIncrement = high.count >= low.count
            } else {
                shouldIncrement = low.count >= high.count
            }

            if shouldIncrement {
                accumulator = accumulator * 2 + 1
            } else {
                accumulator = accumulator * 2
            }

            inputs = inputs.map { $0 >= partition ? $0 - partition : $0 }
            partition = partition / 2
        }

        return accumulator
    }

    static func consumingPartition(_ numbers: [Int], partitionValue: Int, isUpper: Bool) -> Int {
        var partition = partitionValue
        var correction = 0
        var inputs = numbers

        while inputs.count > 1 {
            var low: [Int] = .init()
            var high: [Int] = .init()

            for input in inputs {
                if input < partition {
                    low.append(input)
                } else {
                    high.append(input)
                }
            }
            let shouldIncrement: Bool
            if isUpper {
                shouldIncrement = low.count > high.count
            } else {
                shouldIncrement = low.count <= high.count
            }
            if shouldIncrement {
                inputs = low
                partition = partition / 2
            } else {
                inputs = high.map { $0 - partition }
                correction += partition
                partition = partition / 2
            }
        }

        let finalValue = inputs.first ?? 0

        return finalValue + correction
    }
}
