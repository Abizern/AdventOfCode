import AdventUtilities
import Foundation

public enum Solution13: Solution {
    public static var title = "--- Day 13: Transparent Origami ---"

    public static func part1(_ input: String) -> String {
        let inputs = parse(input)
        let coordinateSet = Set(inputs.0)
        let transform = foldFunction(inputs.1.first!)
        let result = transformPoints(coordinateSet, by: transform).count

        return "\(result)"
    }

    public static func part2(_ input: String) -> String { // -> HECRZKPR
        let inputs = parse(input)
        var coordinateSet = Set(inputs.0)
        let folds = inputs.1

        for fold in folds {
            let transform = foldFunction(fold)
            coordinateSet = transformPoints(coordinateSet, by: transform)
        }

        return codeFrom(coordinateSet)
    }
}

extension Solution13 {
    static func parse(_ input: String) -> ([Point], [Fold]) {
        let parts = input.newlines
        let coordinates = parts.first?.lines.compactMap(Point.init) ?? []
        let folds = parts.last?.lines.compactMap(Fold.init) ?? []
        return (coordinates, folds)
    }
}


extension Solution13 {
    struct Point: Hashable {
        let x: Int
        let y: Int
    }

    enum Fold: Equatable {
        case x(Int)
        case y(Int)
    }

    static func foldFunction(_ fold: Fold) -> (Point) -> Point {
        { point in
            if case .x(let value) = fold {
                guard point.x > value else { return point }
                return Point(x: (2 * value - point.x), y: point.y)
            } else if case .y(let value) = fold {
                guard point.y > value else { return point }
                return Point(x: point.x, y: (2 * value - point.y))
            } else {
                return point
            }
        }
    }

    static func transformPoints(_ points: Set<Point>, by transform: (Point) -> Point) -> Set<Point> {
        Set(points.map(transform))
    }

    static func codeFrom(_ points: Set<Point>) -> String {
        let minX = points.map(\.x).min() ?? 0
        let minY = points.map(\.y).min() ?? 0
        let maxX = points.map(\.x).max() ?? 0
        let maxY = points.map(\.y).max() ?? 0

        var output = "\n"
        (minY ... maxY).forEach {row in
            var line = ""
            (minX ... maxX).forEach { col in
                let point = Point(x: col, y: row)
                if points.contains(point) {
                    line.append("#")
                } else {
                    line.append(" ")
                }
            }
            line.append("\n")
            output.append(line)
        }

        return output
    }
}


extension Solution13.Point {
    init?(_ string: String) {
        let array = string.split(separator: ",").compactMap(String.init)
        guard let sx = array.first,
              let sy = array.last,
              let x = Int.init(sx),
              let y = Int.init(sy)
        else {
            return nil
        }

        self.init(x: x, y: y)
    }
}

extension Solution13.Fold {
    init?(_ string: String) {
        guard let splitIndex = string.firstIndex(of: "=")
        else {
            return nil
        }
        let direction = string[string.index(before: splitIndex)]
        let v = string[string.index(after: splitIndex)...]

        guard let value = Int(String(v)) else { return nil }

        switch direction {
        case "y":
            self = .y(value)
        case "x":
            self = .x(value)
        default:
            return nil
        }
    }
}
