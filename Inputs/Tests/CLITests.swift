import Inputs
import XCTest

final class CLITests: XCTestCase {
    func testYearInitialiserValidYear() {
        let cliYears = ["21"].map(CLI.Year.init(rawValue:))
        XCTAssertEqual(cliYears, [.y21])
    }

    func testYearInitialiserInvalid() {
        XCTAssertNil(CLI.Year(rawValue: "10"))
    }

    func testProblemInitialiserValidDay() {
        let cliProblems = (1..<26).compactMap(CLI.Problem.init(rawValue:))
        XCTAssertEqual(cliProblems, CLI.Problem.allCases)
    }

    func testProblemInitialiserInvalid() {
        XCTAssertNil(CLI.Problem.init(rawValue:0))
    }
}
