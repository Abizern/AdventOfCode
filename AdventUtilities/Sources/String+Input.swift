import Foundation

public extension String {
    /// Just the string, without any extra spaces or nowlines and the beginning and the end
    var safeString: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// The string split on linebreaks
    var lines: [String] {
       safeString.components(separatedBy: .newlines)
    }

    /// The string split on double newlines
    var newlines: [String] {
        safeString.components(separatedBy: "\n\n")
    }

    /// An array from a list of numbers, one number per line
    var ints: [Int] {
        lines.compactMap(Int.init)
    }

    /// An array from a single line of comma separated numbers.
    var intsFromLine: [Int] {
        safeString.components(separatedBy: ",").compactMap(Int.init)
    }

    /// A Set created from a list of numbers, one per line
    var intSet: Set<Int> {
        Set(ints)
    }
}
