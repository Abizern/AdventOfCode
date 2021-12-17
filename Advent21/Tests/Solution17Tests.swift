import XCTest
import Advent21

final class Solutionn17Tests: XCTestCase {
    func testPart1() {
        XCTAssertEqual(Solution17.part1(testInput), "45")
    }

    func testPart2() {
        XCTAssertEqual(Solution17.part2(testInput), "112")
    }
}

private let testInput =
"""
target area: x=20..30, y=-10..-5

"""
