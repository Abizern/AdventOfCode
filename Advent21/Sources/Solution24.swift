import AdventUtilities
import Foundation

public enum Solution24: Solution {
    public static var title = "--- Day 24: Arithmetic Logic Unit ---"

    public static func part1(_ input: String) -> String {
        return "Not Solved Yet"
    }

    public static func part2(_ input: String) -> String {
        return "Not Solved Yet"
    }
}

private extension Solution24 {
    private static func parse(_ input: String) {

    }
}

private extension Solution24 {
    enum Op {
        enum ParamType {
            case key(String)
            case value(Int)
        }

        case inp(String)
        case add(String, ParamType)
        case mul(String, ParamType)
        case div(String, ParamType)
        case mod(String, ParamType)
        case eql(String, ParamType)
    }
}
