import AdventUtilities
import Collections
import CoreFoundation
import Foundation

public enum Solution15: Solution {
    public static var title = "--- Day 15: Chiton ---"

    public static func part1(_ input: String) -> String {
        let grid = Grid(parseInput(input))

        return String(describing: grid.lowestCost(tiles: 1))
    }

    public static func part2(_ input: String) -> String {
        let grid = Grid(parseInput(input))

        return String(describing: grid.lowestCost(tiles: 5))
    }
}

extension Solution15 {
    static func parseInput(_ input: String) -> [[Int]] {
        input.trimmingCharacters(in: .whitespacesAndNewlines).lines.compactMap { $0.compactMap(\.wholeNumberValue) }
    }

    struct Grid {
        struct Point: Hashable {
            let r: Int
            let c: Int
        }

        struct CostElement: Comparable {
            static func < (lhs: Solution15.Grid.CostElement, rhs: Solution15.Grid.CostElement) -> Bool {
                lhs.cost < rhs.cost
            }

            let point: Solution15.Grid.Point
            let cost: Int
        }

        private let dict: [Point: Int]
        private var width: Int
        private var height: Int

        init(_ points: [[Int]]) {
            width = points.first?.count ?? 0
            height = points.count

            var d = [Point: Int]()
            for (j, row) in points.enumerated() {
                for (i, value) in row.enumerated() {
                    d[Point(r: j, c: i)] = value
                }
            }
            dict = d
        }

        func lowestCost(tiles: Int) -> Int {
            func costFor(_ point: Point) -> Int {
                let r = point.r % height
                let c = point.c % width
                let rOffset = point.r / height
                let cOffset = point.c / height


                var value = (dict[Point(r: c, c: r)] ?? 0) + rOffset + cOffset
                while value > 9 {
                    value -= 9
                }

                return value
            }

            func adjacentPointsFor(_ point: Point) -> [Point] {
                let rowRange = (0 ..< height * tiles)
                let colRange = (0 ..< width * tiles)
                var points: [Point] = .init()
                let rowChange = [-1, 0, 1, 0]
                let colChange = [0, 1, 0, -1]

                (0 ..< 4).forEach { changeIdx in
                    let r = point.r + rowChange[changeIdx]
                    let c = point.c + colChange[changeIdx]

                    if rowRange.contains(r) && colRange.contains(c) {
                        points.append(Point(r: r, c: c))
                    }
                }

                return points
            }


            let initialCostElement = CostElement(point: Point(r: 0, c: 0), cost: 0)
            let endPoint = Point(r: (height * tiles) - 1, c: (width * tiles)  - 1)
            var queue = Heap(elements: [initialCostElement], priorityFunction: <)
            var memo = [Point: Int]()

            while !queue.isEmpty {
                let element = queue.pop()!
                let currentPoint = element.point
                let currentCost = costFor(currentPoint) + element.cost
                if currentCost < memo[currentPoint, default: .max] {
                    memo[currentPoint] = currentCost
                } else {
                    continue
                }

                if currentPoint == endPoint {
                    break
                }

                adjacentPointsFor(currentPoint)
                    .map { CostElement(point: $0, cost: currentCost) }
                    .forEach { queue.push($0) }
            }

            return memo[endPoint, default: .max] - dict[Point(r: 0, c: 0)]!
        }
    }
}
