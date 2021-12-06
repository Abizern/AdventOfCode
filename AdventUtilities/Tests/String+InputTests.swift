import AdventUtilities
import Foundation
import XCTest

final class String_InputTests: XCTestCase {
    func testSafeString() {
        XCTAssertEqual(numbersOnLines.safeString, "123\n456\n789")
    }

    func testLines() {
        XCTAssertEqual(numbersOnLines.lines, ["123", "456", "789"])
    }

    func testNewlines() {
        XCTAssertEqual(numbersOnNewlines.newlines, ["123\n456", "789\n321"])
    }

    func testInts() {
        XCTAssertEqual(numbersOnLines.ints, [123, 456, 789])
    }

    func testIntsFromLine() {
        XCTAssertEqual(lineOfNumbers.intsFromLine, [3, 4, 1, 3, 2])
    }

    func testIntSet() {
        XCTAssertEqual(numbersOnLines.intSet, Set([123, 456, 789]))
    }
}

private let numbersOnLines =
"""

123
456
789

"""

private let numbersOnNewlines =
"""

123
456

789
321
"""

private let lineOfNumbers = "3,4,1,3,2"
