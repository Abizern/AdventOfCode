import AdventUtilities
import Algorithms
import Foundation
import Parsing

public enum Solution19: Solution {
    public static var title = "--- Day 19: Beacon Scanner ---"

    public static func part1(_ input: String) -> String {
        let (knowns, unknowns) = parse(input)
        let matched = match(knowns: knowns, unknowns: unknowns)
        let result = matched.map(\.points).reduce(into: Set<Point>()) { allPoints, set in
            allPoints = allPoints.union(set)
        }.count
        return "\(result)"
    }

    public static func part2(_ input: String) -> String {
        let (knowns, unknowns) = parse(input)
        let matched = match(knowns: knowns, unknowns: unknowns)
        let result = matched.map(\.offset).combinations(ofCount: 2).compactMap { pair in
            pair[0].manhattanDistanceTo(pair[1])
        }.max() ?? 0

        return "\(result)"
    }
}


extension Solution19 {
    struct Point: Hashable, CustomStringConvertible {
        var description: String {
            "(\(x), \(y), \(z))"
        }

        let x: Int
        let y: Int
        let z: Int
    }

    struct Known: Equatable {
        let identifier = UUID()
        let offset: Point
        let points: Set<Point>
        let distances: Set<Int>
    }

    struct Unknown: Equatable {
        static func == (lhs: Solution19.Unknown, rhs: Solution19.Unknown) -> Bool {
            lhs.identifier == rhs.identifier
        }

        let identifier = UUID()
        let points: [Set<Point>]
        let distances: Set<Int>

        init(_ points: Set<Point>) {
            var transformed: [Set<Point>] = Self.transformations.map { Set(points.map($0)) }
            transformed.append((points))

            self.points = transformed
            self.distances = Set(points.absoluteDistances())
        }
    }
}

extension Solution19 {

    struct MemoElement: Hashable {
        let known: UUID
        let unknown: UUID
    }

    static func match(knowns: [Known], unknowns: [Unknown] ) -> [Known] {
        var knowns = knowns
        var unknowns = unknowns
        var memo = Set<MemoElement>()

        while !unknowns.isEmpty {
            for known in knowns{
                for unknown in unknowns {
                    let memoElement = MemoElement(known: known.identifier, unknown: unknown.identifier)
                    if memo.contains(memoElement) {
                        continue
                    } else {
                        memo.insert(memoElement)
                    }

                    if let check = matchedSet(known: known, candidates: unknown) {
                        knowns.append(check)
                        unknowns = unknowns.filter { $0 != unknown }
                    }
                }
            }
        }

        return knowns
    }


    static func matchedSet(known: Known, candidates: Unknown) -> Known? {
        guard known.distances.intersection(candidates.distances).count >= 12 else {
            return nil
        }

        var candidates = candidates.points[...]
        var candidate = candidates.popFirst()
        var result: Known?

        while candidate != nil && result == nil {
            guard let c = candidate else { fatalError("Already checked not nil") }
            for trialPoint in known.points {
                for candidatePoint in c {
                    let trialOffset = trialPoint.offset(candidatePoint)
                    let transformed = c.map { $0.offsetBy(trialOffset) }
                    let commonCount = known.points.intersection(transformed).count
                    if commonCount >= 12 {
                        let set = Set(transformed)
                        let distances = Set(set.absoluteDistances())
                        result = Known(offset: trialOffset, points: set, distances: distances)
                        break
                    }
                }
                if result != nil {
                    break
                }
            }

            candidate = candidates.popFirst()
        }

        return result
    }
}

extension Solution19.Point {
    func offset(_ point: Self) -> Self {
        Self.init(x: point.x - x, y: point.y - y, z: point.z - z)
    }

    func offsetBy(_ point: Self) -> Self {
        Self.init(x: x - point.x, y: y - point.y, z: z - point.z)
    }

    func distanceTo(_ point: Self) -> Int {
        let xDiff = x - point.x
        let yDiff = y - point.y
        let zDiff = z - point.z

        return xDiff * xDiff + yDiff * yDiff + zDiff * zDiff
    }

    func manhattanDistanceTo(_ point: Self) -> Int {
        abs(x - point.x) + abs(y - point.y) + abs(z - point.z)
    }
}

extension Solution19.Unknown {
    /*
     Transformations

     Face positive x, y on left z is above Rotate around the x axis (4)
     Face negagive x, y is now on the right (-ve) z above. Rotate around z axis. (4)

     Do the same with y and z (16)

     That's 24
     */

    static var transformations: [(Solution19.Point) -> Solution19.Point] = [
//        { pt in Solution19.Point(x: pt.x, y: pt.y, z: pt.z) },
        { pt in Solution19.Point(x: pt.x, y: -pt.z, z: pt.y) },
        { pt in Solution19.Point(x: pt.x, y: -pt.y, z: -pt.z) },
        { pt in Solution19.Point(x: pt.x, y: pt.z, z: -pt.y) },
        { pt in Solution19.Point(x: -pt.x, y: -pt.y, z: pt.z) },
        { pt in Solution19.Point(x: -pt.x, y: -pt.z, z: -pt.y) },
        { pt in Solution19.Point(x: -pt.x, y: pt.y, z: -pt.z) },
        { pt in Solution19.Point(x: -pt.x, y: pt.z, z: pt.y) },

        { pt in Solution19.Point(x: pt.y, y: -pt.x, z: pt.z) },
        { pt in Solution19.Point(x: pt.y, y: -pt.z, z: -pt.x) },
        { pt in Solution19.Point(x: pt.y, y: pt.x, z: -pt.z) },
        { pt in Solution19.Point(x: pt.y, y: pt.z, z: pt.x) },
        { pt in Solution19.Point(x: -pt.y, y: pt.x, z: pt.z) },
        { pt in Solution19.Point(x: -pt.y, y: pt.z, z: -pt.x) },
        { pt in Solution19.Point(x: -pt.y, y: -pt.x, z: -pt.z) },
        { pt in Solution19.Point(x: -pt.y, y: -pt.z, z: pt.x) },

        { pt in Solution19.Point(x: pt.z, y: -pt.y, z: pt.x) },
        { pt in Solution19.Point(x: pt.z, y: -pt.x, z: -pt.y) },
        { pt in Solution19.Point(x: pt.z, y: pt.y, z: -pt.x) },
        { pt in Solution19.Point(x: pt.z, y: pt.x, z: pt.y) },
        { pt in Solution19.Point(x: -pt.z, y: pt.y, z: pt.x) },
        { pt in Solution19.Point(x: -pt.z, y: -pt.x, z: pt.y) },
        { pt in Solution19.Point(x: -pt.z, y: -pt.y, z: -pt.x) },
        { pt in Solution19.Point(x: -pt.z, y: pt.x, z: -pt.y) }
    ]
}


extension Set where Element == Solution19.Point {
    func absoluteDistances() -> [Int] {
        Array(self).combinations(ofCount: 2).map { $0[0].distanceTo($0[1]) }
    }
}

extension Solution19 {
    static func parse(_ input: String) -> ([Known], [Unknown]) {
        let scanners = input.newlines.compactMap(parseLine).map(Set.init)
        let initialSet = scanners.first!
        let distances = Set(initialSet.absoluteDistances())
        let known = Known(offset: Point(x: 0, y: 0, z: 0), points: initialSet, distances: distances)

        let unknowns = scanners.dropFirst().map(Unknown.init)

        return ([known], unknowns)

    }

    static func parseLine(_ line: String) -> [Point]? {
        let pointParser = Int.parser()
            .skip(",")
            .take(Int.parser())
            .skip(",")
            .take(Int.parser())
            .map { parsed in
                Point(x: parsed.0, y: parsed.1, z: parsed.2)
            }

        return Skip(PrefixThrough("\n"))
            .take(Many(pointParser, separator: "\n")).parse(line)
    }

}
