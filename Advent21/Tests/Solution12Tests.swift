import XCTest
import Advent21

final class Solution12Tests: XCTestCase {
    func testPart1() {
        XCTAssertEqual(Solution12.part1(testInput), "10")
    }

    func testPart2() {
        XCTAssertEqual(Solution12.part2(testInput), "36")
    }
}

private let testInput =
"""
start-A
start-b
A-c
A-b
b-d
A-end
b-end

"""
