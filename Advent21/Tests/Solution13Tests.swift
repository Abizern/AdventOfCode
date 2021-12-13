import XCTest
import Advent21

final class Solution13Tests: XCTestCase {
    func testPart1() {
        XCTAssertEqual(Solution13.part1(testInput), "17")
    }

    func testPart2() {
        XCTAssertEqual(Solution13.part2(testInput), code)
    }
}

private let testInput =
"""
6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5

"""

private let code =
"""

#####
#   #
#   #
#   #
#####

"""
