import XCTest
import Advent21

final class Solutionn16Tests: XCTestCase {
    func testPart1() {
        XCTAssertEqual(Solution16.part1("D2FE28"), "6")
        XCTAssertEqual(Solution16.part1("8A004A801A8002F478"), "16")
        XCTAssertEqual(Solution16.part1("620080001611562C8802118E34"), "12")
        XCTAssertEqual(Solution16.part1("C0015000016115A2E0802F182340"), "23")
        XCTAssertEqual(Solution16.part1("A0016C880162017C3686B18A3D4780"), "31")
    }

    func testPart2() {
        XCTAssertEqual(Solution16.part2("C200B40A82"), "3")
        XCTAssertEqual(Solution16.part2("04005AC33890"), "54")
        XCTAssertEqual(Solution16.part2("880086C3E88112"), "7")
        XCTAssertEqual(Solution16.part2("D8005AC2A8F0"), "1")
        XCTAssertEqual(Solution16.part2("F600BC2D8F"), "0")
        XCTAssertEqual(Solution16.part2("9C005AC2F8F0"), "0")
        XCTAssertEqual(Solution16.part2("9C0141080250320F1802104A08"), "1")
    }
}
