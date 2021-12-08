import XCTest
import Advent21

final class Solution6Tests: XCTestCase {
    func testPart1() {
        XCTAssertEqual(Solution6.part1(testInput), "5934")
    }

    func testPart2() {
        XCTAssertEqual(Solution6.part2(testInput), "26984457539")
    }
}

private let testInput =
"""
3,4,3,1,2

"""
