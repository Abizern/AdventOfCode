import AdventUtilities
import Foundation

public enum Solution16: Solution {
    public static var title = "--- Day 16: Packet Decoder ---"

    public static func part1(_ input: String) -> String {
        let bits = Bitstring(hexString: input.safeString)
        return String(describing: bits.sumOfVersions())
    }

    public static func part2(_ input: String) -> String {
        let bits = Bitstring(hexString: input.safeString)
        return String(describing: bits.evaluate())
    }
}

extension Solution16 {
    struct Bitstring: Equatable {
        let bits: String

        init(hexString: String) {
            bits = hexString.bitString
        }

        func sumOfVersions() -> Int {
            var version = 0
            let _ = evaluate(bits, cursor: bits.startIndex, version_accumulator: &version)
            return version
        }

        func evaluate() -> Int {
            var version = 0
            let (value, _) = evaluate(bits, cursor: bits.startIndex, version_accumulator: &version)
            return value
        }


        private func evaluate(_ string: String,
                              cursor start: String.Index,
                              version_accumulator: inout Int) -> (Int, String.Index) {
            version_accumulator += Int(string[start ..< string.index(start, offsetBy: 3)], radix: 2)! // Only 1 and 0 in string
            let typeId = string[string.index(start, offsetBy: 3) ..< string.index(start, offsetBy: 6)]
            var cursor = string.index(start, offsetBy: 6)
            if typeId == "100" {
                var lastPacket = false
                var value = 0
                while !lastPacket {
                    if string[cursor] == "0" { lastPacket = true }
                    let number = string[string.index(after: cursor) ..< string.index(string.index(after: cursor), offsetBy: 4)]
                    value = (value * 16) + Int(number, radix: 2)!
                    cursor = string.index(cursor, offsetBy: 5)
                }

                return (value, cursor)
            } else {
                var values: [Int] = .init()
                let lengthType = string[cursor]
                cursor = string.index(after: cursor)

                if lengthType == "1" {
                    let cursorOffset = string.index(cursor, offsetBy: 11)
                    let packetCount = Int(string[cursor ..< cursorOffset], radix: 2)!
                    cursor = cursorOffset
                    (0 ..< packetCount).forEach { _ in
                        let (value, nextIndex) = evaluate(string, cursor: cursor, version_accumulator: &version_accumulator)
                        values.append(value)
                        cursor = nextIndex
                    }

                } else {
                    let cursorOffset = string.index(cursor, offsetBy: 15)
                    let bitLength = Int(string[cursor ..< cursorOffset], radix: 2)!
                    cursor = cursorOffset
                    let endCursor = string.index(cursor, offsetBy: bitLength)
                    while cursor < endCursor {
                        let (value, nextIndex) = evaluate(string, cursor: cursor, version_accumulator: &version_accumulator)
                        cursor = nextIndex
                        values.append(value)
                    }
                }

                switch typeId {
                case "000": // sum
                    let v = values.reduce(0, +)
                    return (v, cursor)
                case "001": // product
                    let v = values.reduce(1, *)
                    return (v, cursor)
                case "010": // minimum
                    let v = values.sorted().first ?? 0
                    return (v, cursor)
                case "011": // maximum
                    let v = values.sorted().last ?? 0
                    return (v, cursor)
                case "101": // greater than
                    guard values.count == 2 else { fatalError("incorrect values for greater than \(values)") }
                    return (values[0] > values[1] ? 1 : 0, cursor)
                case "110": // less than
                    guard values.count == 2 else { fatalError("incorrect values for less than \(values)") }
                    return (values[0] < values[1] ? 1 : 0, cursor)
                case "111": // equal
                    guard values.count == 2 else { fatalError("incorrect values for less than \(values)") }
                    return (values[0] == values[1] ? 1 : 0, cursor)
                default:
                    fatalError("Unknown Type Id \(typeId)")
                }
            }
        }
    }
    
}

private extension Character {
    var binaryRepresentation: String? {
        guard let digit = hexDigitValue
        else { return nil }
        var digits = String(digit, radix: 2)
        while digits.count < 4 {
            digits = "0" + digits
        }

        return digits
    }
}

private extension String {
    var bitString: String {
        String(compactMap(\.binaryRepresentation).flatMap { $0 })
    }
}
