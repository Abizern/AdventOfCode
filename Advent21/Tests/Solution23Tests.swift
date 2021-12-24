import XCTest
import Collections
@testable import Advent21

final class Solutionn23Tests: XCTestCase {
    func testCaves() {
        let hallway: [Solution23.Amphipod?] = [.a, .a, nil, .d, nil, nil, nil, nil, nil, nil, .d]
        let aStack = Deque<Solution23.Amphipod>([.a, .d, .d, .b])
        let bStack = Deque<Solution23.Amphipod>([.b, .b, .b])
        let cStack = Deque<Solution23.Amphipod>([.c, .c, .c, .c])
        let dStack = Deque<Solution23.Amphipod>([.a])

        let cave = Solution23.Cave(aStack: aStack, bStack: bStack, cStack: cStack, dStack: dStack, hallway: hallway)

        XCTAssertEqual(Solution23.solve(cave), 15516)
    }

    func testPart1Actual() {
        XCTAssertEqual(Solution23.part1(testInput), "15516")
    }

    func testPart2() {
        XCTAssertEqual(Solution23.part2(testInput), "44169")
    }
}

private let testInput =
"""
#############
#...........#
###B#C#B#D###
  #D#C#B#A#
  #D#B#A#C#
  #A#D#C#A#
  #########

"""
