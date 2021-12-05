import XCTest
import Advent21

final class Solution5Tests: XCTestCase {
    func testPart1() {
        XCTAssertEqual(Solution5.part1(testInput), "5")
    }

    func testPart2() {
        XCTAssertEqual(Solution5.part2(testInput), "12")
    }
}

private let testInput =
"""
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
""".trimmingCharacters(in: .whitespacesAndNewlines)
