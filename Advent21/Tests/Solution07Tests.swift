import XCTest
import Advent21

final class Solution7Tests: XCTestCase {
    func testPart1() {
        XCTAssertEqual(Solution7.part1(testInput), "37")
    }

    func testPart2() {
        XCTAssertEqual(Solution7.part2(testInput), "168")
    }
}

private let testInput =
"""
16,1,2,0,4,2,7,1,2,14
""".trimmingCharacters(in: .whitespacesAndNewlines)
