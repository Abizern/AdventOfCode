import XCTest
import Advent21

final class Solutionn21Tests: XCTestCase {
    func testPart1() {
        XCTAssertEqual(Solution21.part1(testInput), "739785")
    }

    func testPart2() {
        XCTAssertEqual(Solution21.part2(testInput), "444356092776315")
    }
}

private let testInput =
"""
Player 1 starting position: 4
Player 2 starting position: 8

"""
