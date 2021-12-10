import XCTest
import Advent21

final class Solution10Tests: XCTestCase {
    func testPart1() {
        XCTAssertEqual(Solution10.part1(testInput), "26397")
    }

    func testPart2() {
        XCTAssertEqual(Solution10.part2(testInput), "288957")
    }
}

private let testInput =
"""
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]

"""
