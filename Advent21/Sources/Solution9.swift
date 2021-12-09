import AdventUtilities
import Swift

public enum Solution9: Solution {
    public static var title = "--- Day 9: Smoke Basin ---"

    public static func part1(_ input: String) -> String {
        let grid = Grid(parseInput(input))
        return String(describing: grid.heightValue)
    }

    public static func part2(_ input: String) -> String {
        let grid = Grid(parseInput(input))
        return String(describing: grid.largestSinkSizes)
    }
}

extension Solution9 {
    static func parseInput(_ input: String) -> [[Int]] {
        input.trimmingCharacters(in: .whitespacesAndNewlines).lines.compactMap { $0.compactMap(\.wholeNumberValue) }
    }

    struct Grid {
        struct Point: Hashable {
            let r: Int
            let c: Int
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

        private func adjacentPoints(_ pt: Point) -> [Point] {
            let rowRange = (0 ..< height)
            let colRange = (0 ..< width)
            var points: [Point] = .init()
            let rowChange = [-1, 0, 1, 0]
            let colChange = [0, 1, 0, -1]
            (0 ..< 4).forEach { changeIdx in
                let r = pt.r + rowChange[changeIdx]
                let c = pt.c + colChange[changeIdx]

                if rowRange.contains(r) && colRange.contains(c) {
                    points.append(Point(r: r, c: c))
                }
            }

            return points
        }

        private func drainage(_ pt: Point) -> Point? {
            guard let height = dict[pt] else { return nil }
            let minimum = adjacentPoints(pt)
                    .map { ($0, dict[$0] ?? Int.max) }
            .reduce((pt, height)) { min, pt in
                if pt.1 < min.1 {
                    return pt
                } else {
                    return min
                }
            }.0
            return minimum != pt ?  minimum :  nil
        }

        func sinkDictionary() -> [Point: Point] {
            var sinks: [Point: Point] = .init()
            for point in dict.keys {
                if dict[point] == 9 || sinks[point] != nil {
                    continue
                }
                var connectedPoints = [point]
                var sinkPoint = point
                var drainPoint = drainage(sinkPoint)

                while drainPoint != nil {
                    if sinks[drainPoint!] != nil {
                        sinkPoint = sinks[drainPoint!]!
                        break
                    }
                    sinkPoint = drainPoint!
                    connectedPoints.append(sinkPoint)
                    drainPoint = drainage(sinkPoint)
                }

                for connectedPoint in connectedPoints {
                    sinks[connectedPoint] = sinkPoint
                }
            }

            return sinks
        }

        var heightValue: Int {
            Array(Set(sinkDictionary().values)).compactMap { dict[$0] }.map{ $0 + 1}.reduce(0, +)
        }

        var largestSinkSizes: Int {
            Dictionary(sinkDictionary().values.map { ($0, 1) }, uniquingKeysWith: +)
                .map { $1 }
                .sorted()
                .reversed()
                .prefix(3)
                .reduce(1, *)
        }
    }
}
