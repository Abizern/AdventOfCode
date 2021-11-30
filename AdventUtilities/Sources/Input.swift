import Foundation

public enum Input {
    public static func string(from url: URL) -> String {
        do {
            return try String(contentsOf: url).trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
