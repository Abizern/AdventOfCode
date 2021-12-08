import XCTest
@testable import Advent21

final class Solution2Tests: XCTestCase {
    func testInstruction() {
        XCTAssertEqual(Solution2.Instruction("forward", 3), .forward(3))
        XCTAssertEqual(Solution2.Instruction("up", 2), .up(2))
        XCTAssertEqual(Solution2.Instruction("down", 1), .down(1))
        XCTAssertNil(Solution2.Instruction("aaaa", 5))
    }

    func testParser() {
        let parsed = Solution2.parseInput(testInput)
        XCTAssertEqual(parsed.count, 6)
        XCTAssertEqual(parsed, [.forward(5), .down(5), .forward(8), .up(3), .down(8), .forward(2)])
    }
    func testPart1() throws {
        XCTAssertEqual(Solution2.part1(testInput), "150")
    }

    func testPart2() throws {
        XCTAssertEqual(Solution2.part2(testInput), "900")
    }
}

private let testInput =
"""
forward 5
down 5
forward 8
up 3
down 8
forward 2

"""
