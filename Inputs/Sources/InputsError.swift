import Foundation

public enum InputsError: Error {
case fileNotFound(String)
}

extension InputsError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .fileNotFound(let string):
            return NSLocalizedString("File at \(string) cannot be found", comment: "")
        }
    }
}
