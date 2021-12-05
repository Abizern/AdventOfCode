import AdventUtilities
import Foundation
import Parsing

public enum Solution5: Solution {
    public static var title = "--- Day 5: Hydrothermal Venture ---"

    public static func part1(_ input: String) -> String {
        guard let segments = Many(segmentParser, separator: "\n").parse(input)
        else {
            return "Input could not be read"
        }

        return "\(segments.filter{ $0.orientation != .diagonal}.countIntersections)"
    }

    public static func part2(_ input: String) -> String {
        guard let segments = Many(segmentParser, separator: "\n").parse(input)
        else {
            return "Input could not be read"
        }

        return "\(segments.countIntersections)"
    }
}

extension Solution5 {
    struct Point: Equatable, Hashable, Comparable {
        static func < (lhs: Solution5.Point, rhs: Solution5.Point) -> Bool {
            if lhs.x == rhs.x {
                return lhs.y < rhs.y
            } else {
                return lhs.x < rhs.x
            }
        }

        let x: Int
        let y: Int

        func incrementing(dx: Int, dy: Int) -> Point {
            Point(x: x + dx, y: y + dy)
        }
    }

    struct Segment: Equatable {
        enum Orientation: Equatable {
            case horizontal
            case vertical
            case diagonal
        }

        let start: Point
        let end: Point
        let orientation: Orientation

        init(pt1: Point, pt2: Point) {
            self.start = min(pt1, pt2)
            self.end = max(pt1,pt2)
            switch (pt1, pt2) {
            case let(a, b) where a.x == b.x:
                self.orientation = .vertical
            case let(a, b) where a.y == b.y:
                self.orientation = .horizontal
            default:
                self.orientation = .diagonal
            }
        }

        var points: [Point] {
            switch orientation {
            case .horizontal:
                return horizontalPoints
            case .vertical:
                return verticalPoints
            case .diagonal:
                return diagonalPoints
            }
        }

        var horizontalPoints: [Point] {
            guard start != end else { return [start] }
            return (0 ... abs(start.x - end.x)).map { start.incrementing(dx: $0, dy: 0) }
        }

        var verticalPoints: [Point] {
            guard start != end else { return [start] }
            return (0 ... abs(start.y - end.y)).map {start.incrementing(dx: 0, dy: $0) }
        }

        var diagonalPoints: [Point] {
            let diff = abs(start.x - end.x)
            let range = stride(from: 0, through: diff, by: 1)
            switch (start.x, end.x, start.y, end.y) {
            case let (a, b, c, d) where a < b && c < d:
                return range.map { start.incrementing(dx: $0, dy: $0) }
            case let (a, b, c, d) where a < b && c > d:
                return range.map { start.incrementing(dx: $0, dy: -$0) }
            case let (a, b, c, d) where a > b && c < d:
                return range.map { start.incrementing(dx: -$0, dy: $0) }
            case let (a, b, c, d) where a > b && c > d:
                return range.map { start.incrementing(dx: -$0, dy: -$0) }
            default:
                return []
            }
        }
    }
}

extension Solution5 {
    static var segmentParser: AnyParser<Substring, Segment> {
        Int.parser()
            .skip(StartsWith(","))
            .take(Int.parser())
            .skip(StartsWith(" -> "))
            .take(Int.parser())
            .skip(StartsWith(","))
            .take(Int.parser())
            .map { a, b, c, d in
                Solution5.Segment(pt1: Solution5.Point(x: a, y: b), pt2: Solution5.Point(x: c, y: d))
            }
            .eraseToAnyParser()
    }

    static func countIntersections(_ segments: [Segment]) -> Int {
        var memo = [Point: Int]()
        segments
            .forEach { segment in
                for point in segment.points {
                    memo[point, default: 0] += 1
                }
            }

        return memo.filter { element in
            element.value > 1
        }
        .keys
        .count
    }
}

extension Array where Element == Solution5.Segment {
    var countIntersections: Int {
        var memo = [Solution5.Point: Int]()

        forEach { segment in
            for point in segment.points {
                memo[point, default: 0] += 1
            }
        }

        return memo
            .filter { $0.value > 1 }
            .keys
            .count
    }
}
