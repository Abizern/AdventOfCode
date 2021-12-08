import XCTest
import Advent21

final class Solution1Tests: XCTestCase {
    func testPart1() throws {
        XCTAssertEqual(Solution1.part1(testInput), "7")
    }

    func testPart2() throws {
        XCTAssertEqual(Solution1.part2(testInput), "5")
    }
}

private let testInput =
"""
199
200
208
210
200
207
240
269
260
263

"""
