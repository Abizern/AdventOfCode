import Foundation

public protocol Solution {
    static var title: String { get }
    static func part1(_ input: String) -> String
    static func part2(_ input: String) -> String
}



