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
    struct Point: Equatable, Hashable {
        let x: Int
        let y: Int
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

        init(start: Point, end: Point) {
            self.start = start
            self.end = end
            switch (start, end) {
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
            guard start.x != end.x else { return [start] }
            return (min(start.x, end.x) ... max(start.x, end.x)).map { Point(x: $0, y: start.y) }
        }

        var verticalPoints: [Point] {
            guard start.y != end.y else { return [start] }
            return (min(start.y, end.y) ... max(start.y, end.y)).map { Point(x: start.x, y: $0) }
        }

        var diagonalPoints: [Point] {
            let diff = abs(start.x - end.x)
            let range = stride(from: 0, through: diff, by: 1)
            switch (start.x, end.x, start.y, end.y) {
            case let (a, b, c, d) where a < b && c < d:
                return range.map { n in
                    Point(x: start.x + n, y: start.y + n)
                }
            case let (a, b, c, d) where a < b && c > d:
                return range.map { n in
                    Point(x: start.x + n, y: start.y - n)
                }
            case let (a, b, c, d) where a > b && c < d:
                return range.map { n in
                    Point(x: start.x - n, y: start.y + n)
                }
            case let (a, b, c, d) where a > b && c > d:
                return range.map { n in
                    Point(x: start.x - n, y: start.y - n)
                }
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
                Solution5.Segment(start: Solution5.Point(x: a, y: b), end: Solution5.Point(x: c, y: d))
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
