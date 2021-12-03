import XCTest
import Advent21

final class Solution3Tests: XCTestCase {
    func testPart1() {
        XCTAssertEqual(Solution3.part1(testInput), "198")
    }

    func testPart2() {
        XCTAssertEqual(Solution3.part2(testInput), "230")
    }
}

private let testInput =
"""
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
""".trimmingCharacters(in: .whitespacesAndNewlines)
