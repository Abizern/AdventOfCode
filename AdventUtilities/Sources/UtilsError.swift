import Foundation

public enum UtilsError: Error {
    case notImplemented
    case intConversion(String)
}

extension UtilsError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notImplemented:
            return NSLocalizedString("Not implemented yet", comment: "")
        case .intConversion(let string):
            return NSLocalizedString("\(string) cannot be converted to Int", comment: "")
        }
    }
}
