import XCTest
import Advent21

final class Solution9Tests: XCTestCase {
    func testPart1() {
        XCTAssertEqual(Solution9.part1(testInput), "15")
    }

    func testPart2() {
        XCTAssertEqual(Solution9.part2(testInput), "1134")
    }
}

private let testInput =
"""
2199943210
3987894921
9856789892
8767896789
9899965678

"""
