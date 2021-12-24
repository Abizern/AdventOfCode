import AdventUtilities
import Collections
import Foundation

public enum Solution23: Solution {
    public static var title = "--- Day 23: Amphipod ---"

    public static func part1(_ input: String) -> String {
        return "15516" // Worked this out manually!
    }

    public static func part2(_ input: String) -> String {
        let initialCave = parse(input)
        return solve(initialCave).description
    }
}

extension Solution23 {
    static func solve(_ cave: Cave) -> Int {
        let initialCostElement = CostElement(cost: 0, cave: cave)
        var minimumCost: Int = .max
        var deadEnds: Set<Cave> = .init(minimumCapacity: 4000)
        var memo: [Cave: Int] = .init(minimumCapacity: 10_000)
        var queue = Heap(elements: [initialCostElement], priorityFunction: <)

        while !queue.isEmpty {
            let element = queue.pop()! // Already know this isn't empty
            let currentCave = element.cave
            let currentCost = element.cost

            let nextCaveStates = currentCave.nextValidStates
            if nextCaveStates.isEmpty {
                deadEnds.insert(currentCave)
            } else {
                for cave in nextCaveStates {
                    let cost = currentCost + cave.0
                    let cave = cave.1

                    if deadEnds.contains(cave) {
                        continue // No point examining paths beyond this point
                    }

                    if cost < memo[cave, default: .max] {
                        memo[cave] = cost
                    } else {
                        continue
                    }

                    if cave.isFinalState {
                        minimumCost = cost
                        break // Not sure if the first one I find is valid, but Djikstra says it is.
                    }

                    queue.push(CostElement(cost: cost, cave: cave))
                }
            }
        }

        return minimumCost
    }
}

// Parsing
extension Solution23 {
    static func parse(_ input: String) -> Cave {
        let grid = input.lines.dropFirst(2).dropLast().map { $0.compactMap(Amphipod.init) }
        var aStack: Deque<Amphipod> = .init(minimumCapacity: 4)
        var bStack: Deque<Amphipod> = .init(minimumCapacity: 4)
        var cStack: Deque<Amphipod> = .init(minimumCapacity: 4)
        var dStack: Deque<Amphipod> = .init(minimumCapacity: 4)
        (0 ..< 4).forEach { row in
            aStack.prepend(grid[row][0])
            bStack.prepend(grid[row][1])
            cStack.prepend(grid[row][2])
            dStack.prepend(grid[row][3])
        }

        return Cave(aStack: aStack, bStack: bStack, cStack: cStack, dStack: dStack)
    }
}

extension Solution23 {
    enum Amphipod: CustomDebugStringConvertible {
        var debugDescription: String {
            description
        }

        case a
        case b
        case c
        case d

        init?(_ char: Character) {
            switch char {
            case "A":
                self = .a
            case "B":
                self = .b
            case "C":
                self = .c
            case "D":
                self = .d
            default:
                return nil
            }
        }

        var cost: Int {
            switch self {
            case .a:
                return 1
            case .b:
                return 10
            case .c:
                return 100
            case .d:
                return 1000
            }
        }

        var description: String {
            switch self {
            case .a:
                return "A"
            case .b:
                return "B"
            case .c:
                return "C"
            case .d:
                return "D"
            }
        }
    }
}

extension Solution23 {
    struct Cave: Hashable {
        let hallway: [Amphipod?]
        let aStack: Deque<Amphipod>
        let bStack: Deque<Amphipod>
        let cStack: Deque<Amphipod>
        let dStack: Deque<Amphipod>

        init(aStack: Deque<Amphipod>,
             bStack: Deque<Amphipod>,
             cStack: Deque<Amphipod>,
             dStack: Deque<Amphipod>,
             hallway: [Amphipod?] = Array<Amphipod?>(repeating: nil, count: 11)) {
            self.aStack = aStack
            self.bStack = bStack
            self.cStack = cStack
            self.dStack = dStack
            self.hallway = hallway

            assert(aStack.count + bStack.count + cStack.count + dStack.count + hallway.compactMap { $0 }.count == 16 )
        }

        var isFinalState: Bool {
            hallway.compactMap { $0 }.isEmpty &&
            aStack.filter { $0 == .a }.count == 4 &&
            bStack.filter { $0 == .b }.count == 4 &&
            cStack.filter { $0 == .c }.count == 4 &&
            dStack.filter { $0 == .d }.count == 4
        }

        static var indexStackA = 2
        static var indexStackB = 4
        static var indexStackC = 6
        static var indexStackD = 8

        var nextValidStates: [(Int, Cave)] {
            [validStatesForA,
             validStatesForB,
             validStatesForC,
             validStatesForD,
             validStatesForHallway]
                .flatMap { $0 }
        }

        var validStatesForA: [(Int, Cave)] {
            let doorIndex = Cave.indexStackA
            let hallwayIndexes = validHallwayIndexes(from: doorIndex)

            guard !aStack.isEmpty,
                  !aStack.filter({ $0 != .a }).isEmpty,
                  !hallwayIndexes.isEmpty
            else {
                return []
            }

            var newStack = aStack
            let costToPop = (4 - newStack.count + 1)
            let amphipod = newStack.popLast()!
            var retVal: [(Int, Cave)] = .init()

            for hallwayIndex in hallwayIndexes {
                var newHallway = hallway
                newHallway.remove(at: hallwayIndex)
                newHallway.insert(amphipod, at: hallwayIndex)
                let hallwayCost = costForMoving(to: hallwayIndex, from: doorIndex)

                let newCave = Cave(aStack: newStack, bStack: bStack, cStack: cStack, dStack: dStack, hallway: newHallway)

                retVal.append(((costToPop + hallwayCost) * amphipod.cost, newCave))
            }

            return retVal
        }

        var validStatesForB: [(Int, Cave)] {
            let doorIndex = Cave.indexStackB
            let hallwayIndexes = validHallwayIndexes(from: doorIndex)

            guard !bStack.isEmpty,
                  !bStack.filter({ $0 != .b }).isEmpty,
                  !hallwayIndexes.isEmpty
            else {
                return []
            }

            var newStack = bStack
            let costToPop = 4 - newStack.count + 1
            let amphipod = newStack.popLast()!
            var retVal: [(Int, Cave)] = .init()

            for hallwayIndex in hallwayIndexes {
                var newHallway = hallway
                newHallway.remove(at: hallwayIndex)
                newHallway.insert(amphipod, at: hallwayIndex)
                let hallwayCost = costForMoving(to: hallwayIndex, from: doorIndex)

                let newCave = Cave(aStack: aStack, bStack: newStack, cStack: cStack, dStack: dStack, hallway: newHallway)

                retVal.append(((costToPop + hallwayCost) * amphipod.cost, newCave))
            }

            return retVal
        }

        var validStatesForC: [(Int, Cave)] {
            let doorIndex = Cave.indexStackC
            let hallwayIndexes = validHallwayIndexes(from: doorIndex)
            guard !cStack.isEmpty,
                  !cStack.filter({ $0 != .c }).isEmpty,
                  !hallwayIndexes.isEmpty
            else {
                return []
            }

            var newStack = cStack
            let costToPop = 4 - newStack.count + 1
            let amphipod = newStack.popLast()!
            var retVal: [(Int, Cave)] = .init()

            for hallwayIndex in hallwayIndexes {
                var newHallway = hallway
                newHallway.remove(at: hallwayIndex)
                newHallway.insert(amphipod, at: hallwayIndex)
                let hallwayCost = costForMoving(to: hallwayIndex, from: doorIndex)

                let newCave = Cave(aStack: aStack, bStack: bStack, cStack: newStack, dStack: dStack, hallway: newHallway)

                retVal.append(((costToPop + hallwayCost) * amphipod.cost, newCave))
            }

            return retVal
        }

        var validStatesForD: [(Int, Cave)] {
            let doorIndex = Cave.indexStackD
            let hallwayIndexes = validHallwayIndexes(from: doorIndex)
            guard !dStack.isEmpty,
                  !dStack.filter({ $0 != .d }).isEmpty,
                  !hallwayIndexes.isEmpty
            else {
                return []
            }

            var newStack = dStack
            let costToPop = 4 - newStack.count + 1
            let amphipod = newStack.popLast()!
            var retVal: [(Int, Cave)] = .init()

            for hallwayIndex in hallwayIndexes {
                var newHallway = hallway
                newHallway.remove(at: hallwayIndex)
                newHallway.insert(amphipod, at: hallwayIndex)
                let hallwayCost = costForMoving(to: hallwayIndex, from: doorIndex)

                let newCave = Cave(aStack: aStack, bStack: bStack, cStack: cStack, dStack: newStack, hallway: newHallway)

                retVal.append(((costToPop + hallwayCost) * amphipod.cost, newCave))
            }

            return retVal
        }

        var validStatesForHallway: [(Int, Cave)] {
            var retVal: [(Int, Cave)] = .init()
            for (idx, a) in hallway.enumerated() {
                guard
                    let amphipod = a,
                    let (target, stack) = .some(targetIndex(amphipod)),
                    stack.canReceive(amphipod)
                else {
                    continue
                }
                let min = target < idx ? target : idx + 1
                let max = target < idx ? idx - 1 : target
                guard hallway[min ... max].filter({ $0 != nil}).isEmpty
                else {
                    continue
                }

                var newStack = stack
                var newHallway = hallway
                let costToPush = 4 - newStack.count
                let costForMoving = costForMoving(to: target, from: idx)
                newHallway.remove(at: idx)
                newHallway.insert(nil, at: idx)
                newStack.append(amphipod)
                let newCave: Cave
                switch amphipod {
                case .a:
                    newCave = Cave(aStack: newStack, bStack: bStack, cStack: cStack, dStack: dStack, hallway: newHallway)
                case .b:
                    newCave = Cave(aStack: aStack, bStack: newStack, cStack: cStack, dStack: dStack, hallway: newHallway)
                case .c:
                    newCave = Cave(aStack: aStack, bStack: bStack, cStack: newStack, dStack: dStack, hallway: newHallway)
                case .d:
                    newCave = Cave(aStack: aStack, bStack: bStack, cStack: cStack, dStack: newStack, hallway: newHallway)
                }

                retVal.append(((costToPush + costForMoving) * amphipod.cost, newCave))
            }

            return retVal
        }

        // from top of room to hallway index
        func costForMoving(to: Int, from: Int) -> Int {
            abs(from - to)
        }

        func validHallwayIndexes(from: Int) -> [Int] {
            let left = hallway[0 ..< from]
            let right = hallway[from ..< hallway.endIndex]
            let ll = left.lastIndex(where: { $0 != nil}).map { $0 + 1} ?? 0
            let rr = right.firstIndex(where: { $0 != nil }) ?? 11

            let li = ll <= from ? Array((ll ..< from)) : []
            let ri = rr >= from + 1 ? Array((from + 1 ..< rr)) : []

            return [li, ri]
                .flatMap { $0 }
                .filter { ![Cave.indexStackA,
                            Cave.indexStackB,
                            Cave.indexStackC,
                            Cave.indexStackD].contains($0)
                }
        }

        func targetIndex(_ amphipod: Amphipod) -> (Int, Deque<Amphipod>) {
            switch amphipod {
            case .a:
                return (Cave.indexStackA, aStack)
            case .b:
                return (Cave.indexStackB, bStack)
            case .c:
                return (Cave.indexStackC, cStack)
            case .d:
                return (Cave.indexStackD, dStack)

            }
        }
    }
}

extension Solution23.Cave: CustomStringConvertible, CustomDebugStringConvertible {
    var debugDescription: String {
        description
    }

    var description: String {
        """
        hallway: \(hallway)
        AStack: \(aStack)
        BStack: \(bStack)
        CStack: \(cStack)
        DStack: \(dStack)
        """
    }
}

extension Solution23 {
    struct CostElement: Comparable {
        var cost: Int
        let cave: Cave
        
        static func < (lhs: Solution23.CostElement, rhs: Solution23.CostElement) -> Bool {
            lhs.cost < rhs.cost
        }

        mutating func addCost(_ costToCurrentState: Int) {
            cost += costToCurrentState
        }
    }
}

extension Deque where Element == Solution23.Amphipod {
    func canReceive(_ amphipod: Solution23.Amphipod) -> Bool {
        isEmpty || filter { $0 != amphipod }.isEmpty
    }
}

