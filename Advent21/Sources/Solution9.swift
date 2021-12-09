import AdventUtilities
import Swift

public enum Solution9: Solution {
    public static var title = "--- Day 9: Smoke Basin ---"

    public static func part1(_ input: String) -> String {
        let grid = parseInput(input)
        let rows = grid.count
        let cols = grid[0].count
        let rowRange = (0 ..< rows)
        let colRange = (0 ..< cols)

        var heightValue = 0
        rowRange.forEach { row in
            colRange.forEach { col in
                var isLowest = true
                let rowChange = [-1, 0, 1, 0]
                let colChange = [0, 1, 0, -1]
                (0 ..< 4).forEach { changeIdx in
                    let r = row + rowChange[changeIdx]
                    let c = col + colChange[changeIdx]

                    if rowRange.contains(r) && colRange.contains(c) && grid[r][c] <= grid[row][col] {
                        isLowest = false
                    }
                }
                if isLowest {
                    heightValue += grid[row][col] + 1
                }
            }
        }

        return String(describing: heightValue)
    }

    public static func part2(_ input: String) -> String {
        "Not Solved Yet"
    }
}

extension Solution9 {
    struct Point: Hashable {
        let x: Int
        let y: Int
    }
    static func parseInput(_ input: String) -> [[Int]] {
        input.trimmingCharacters(in: .whitespacesAndNewlines).lines.compactMap { $0.compactMap(\.wholeNumberValue) }
    }
}
