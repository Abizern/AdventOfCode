import AdventUtilities
import XCTest

final class InputTests: XCTestCase {
    func testString() throws {
        guard let url = Bundle.module.url(forResource: "Resources/numbersOnLines", withExtension: "txt") else { XCTFail("File not found")
            return
        }

        let input = Input.string(from: url)
        XCTAssertEqual(input, "123\n456\n789")
    }
}
