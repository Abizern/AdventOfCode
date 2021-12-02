import Foundation

public protocol Year {
    static var title: String { get }
    static var solutions: [Solution.Type] { get }
}
