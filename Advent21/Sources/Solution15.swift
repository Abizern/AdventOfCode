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

        var lowestCost: Int {
            let initialCostElement = CostElement(point: Point(r: 0, c: 0), cost: 0)
            var queue = Heap(elements: [initialCostElement], priorityFunction: <)
            var visited = Set<Point>()
            var cost = 0
            while !queue.isEmpty {
                let element = queue.pop()!
                let currentPoint = element.point
                let currentCost = (dict[element.point] ?? 0) + element.cost
                visited.insert(currentPoint)
                if currentPoint == Point(r: height - 1, c: width - 1) {
                    cost = currentCost
                    break
                }

                adjacentPoints(element.point)
                    .filter { !visited.contains($0) }
                    .map { CostElement(point: $0, cost: currentCost) }
                    .forEach { queue.push($0) }
            }

            return cost - dict[Point(r: 0, c: 0)]!
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

// https://www.raywenderlich.com/586-swift-algorithm-club-heap-and-priority-queue-data-structure
// Bit cheaty, but I'm in a hurry


struct Heap<Element> {
    var elements : [Element]
    let priorityFunction : (Element, Element) -> Bool

    init(elements: [Element] = [], priorityFunction: @escaping (Element, Element) -> Bool) {
        self.elements = elements
        self.priorityFunction = priorityFunction
        buildHeap()
    }

    mutating func buildHeap() {
        for index in (0 ..< count / 2).reversed() {
            siftDown(elementAtIndex: index)
        }
    }

    var isEmpty : Bool {
         elements.isEmpty
    }

    var count : Int {
         elements.count
    }

    func peek() -> Element? {
         elements.first
    }

    func isRoot(_ index: Int) -> Bool {
         (index == 0)
    }

    func leftChildIndex(of index: Int) -> Int {
         (2 * index) + 1
    }

    func rightChildIndex(of index: Int) -> Int {
         (2 * index) + 2
    }

    func parentIndex(of index: Int) -> Int {
         (index - 1) / 2
    }

    func isHigherPriority(at firstIndex: Int, than secondIndex: Int) -> Bool {
         priorityFunction(elements[firstIndex], elements[secondIndex])
    }

    func highestPriorityIndex(of parentIndex: Int, and childIndex: Int) -> Int {
        guard childIndex < count && isHigherPriority(at: childIndex, than: parentIndex)
        else { return parentIndex }
        return childIndex
    }

    func highestPriorityIndex(for parent: Int) -> Int {
         highestPriorityIndex(of: highestPriorityIndex(of: parent, and: leftChildIndex(of: parent)), and: rightChildIndex(of: parent))
    }

    mutating func swapElement(at firstIndex: Int, with secondIndex: Int) {
        guard firstIndex != secondIndex
        else { return }
        elements.swapAt(firstIndex, secondIndex)
    }

    mutating func push(_ element: Element) {
        elements.append(element)
        siftUp(elementAtIndex: count - 1)
    }

    mutating func siftUp(elementAtIndex index: Int) {
        let parent = parentIndex(of: index)
        guard !isRoot(index),
              isHigherPriority(at: index, than: parent)
        else { return }
        swapElement(at: index, with: parent)
        siftUp(elementAtIndex: parent)
    }

    mutating func pop() -> Element? {
        guard !isEmpty
        else { return nil }
        swapElement(at: 0, with: count - 1)
        let element = elements.removeLast()
        if !isEmpty {
            siftDown(elementAtIndex: 0)
        }
        return element
    }

    mutating func siftDown(elementAtIndex index: Int) {
        let childIndex = highestPriorityIndex(for: index)
        if index == childIndex {
            return
        }
        swapElement(at: index, with: childIndex)
        siftDown(elementAtIndex: childIndex)
    }
}
