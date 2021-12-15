import XCTest
import Advent21

final class Solution15Tests: XCTestCase {
    func testPart1() {
        XCTAssertEqual(Solution15.part1(testInput), "40")
    }

    func testPart2() {
        XCTAssertEqual(Solution15.part2(testInput), "315")
    }
}

private let testInput =
"""
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581

"""
