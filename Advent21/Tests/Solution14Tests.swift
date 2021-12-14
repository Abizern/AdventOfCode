import XCTest
import Advent21

final class Solution14Tests: XCTestCase {
    func testPart1() {
        XCTAssertEqual(Solution14.part1(testInput), "1588")
    }

    func testPart2() {
        XCTAssertEqual(Solution14.part2(testInput), "2188189693529")
    }
}

private let testInput =
"""
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C

"""
