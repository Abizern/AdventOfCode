import XCTest
import Advent21

final class Solution11Tests: XCTestCase {
    func testPart1() {
        XCTAssertEqual(Solution11.part1(testInput), "1656")
    }

    func testPart2() {
        XCTAssertEqual(Solution11.part2(testInput), "195")
    }
}

private let testInput =
"""
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526

"""

private let smallInput =
"""
11111
19991
19191
19991
11111

"""
