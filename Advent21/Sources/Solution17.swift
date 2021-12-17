import AdventUtilities
import Foundation
import Parsing

public enum Solution17: Solution {
    public static var title = "--- Day 17: Trick Shot ---"

    public static func part1(_ input: String) -> String {
        let (_, maxHeight) = evaluate(parse(input))

        return "\(maxHeight)"
    }

    public static func part2(_ input: String) -> String {
        let (count, _) = evaluate(parse(input))

        return "\(count)"
    }
}

extension Solution17 {
    static func parse(_ input: String) -> (Int, Int, Int, Int) {

        guard let values = Skip("target area: x=").take(Int.parser()).skip("..").take(Int.parser()).skip(", y=").take(Int.parser()).skip("..").take(Int.parser()).parse(input) else {
            fatalError("Can't parse input \(input)")
        }

        return values
    }

    static func evaluate(_ targetValues: (Int, Int, Int, Int)) -> (Int, Int) {
        let (x1, x2, y1, y2) = targetValues
        let minX = min(x1, x2)
        let maxX = max(x1, x2)
        let minY = min(y1, y2)
        let maxY = max(y1, y2)

        var maxHeightReached = Int.min
        var count = 0
        (0 ... maxX).forEach { initialX in
            (minY ... max(maxY, abs(minY))).forEach { initialY in
                var maxHeight = Int.min
                var found = false
                var currentX = 0
                var currentY = 0
                var vX = initialX
                var vY = initialY

                while !found && currentX < maxX && currentY > minY {
                    currentX += vX
                    currentY += vY
                    maxHeight = max(currentY, maxHeight)
                    if vX > 0 { vX -= 1 }
                    vY -= 1
                    if (minX ... maxX).contains(currentX) && (minY ... maxY).contains(currentY) {
                        found = true
                        continue
                    }
                }

                if found {
                    count += 1
                    maxHeightReached = max(maxHeightReached, maxHeight)
                }
            }
        }

        return (count, maxHeightReached)
    }
}
