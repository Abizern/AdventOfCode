import AdventUtilities
import Foundation
import Collections

public enum Solution10: Solution {
    public static var title = "--- Day 10: Syntax Scoring ---"

    public static func part1(_ input: String) -> String {
        String(describing: input.lines.compactMap(syntaxScore).reduce(0, +))
    }

    public static func part2(_ input: String) -> String {
        let results = input.lines.compactMap(autoCompletionScore).sorted()
        let midpoint = (results.count - 1) / 2
        return String(describing: results[midpoint])
    }
}

extension Solution10 {
    static func syntaxScore(_ line: String) -> Int? {
        var stack = Deque<Character>()
        for character in line {
            switch character {
            case "(", "[", "{", "<":
                stack.append(character)
            case ")":
                if stack.popLast() != "(" {
                    return 3
                }
            case "]":
                if stack.popLast() != "[" {
                    return 57
                }
            case "}":
                if stack.popLast() != "{" {
                    return 1197
                }
            case ">":
                if stack.popLast() != "<" {
                    return 25137
                }
            default:
                break
            }
        }
        return nil
    }

    static func autoCompletionScore(_ line: String) -> Int? {
        var stack = Deque<Character>()
        for character in line {
            switch character {
            case "(", "[", "{", "<":
                stack.prepend(character)
            case ")":
                if stack.popFirst() != "(" {
                    return nil
                }
            case "]":
                if stack.popFirst() != "[" {
                    return nil
                }
            case "}":
                if stack.popFirst() != "{" {
                    return nil
                }
            case ">":
                if stack.popFirst() != "<" {
                    return nil
                }
            default:
                break
            }
        }
        var score = 0
        while !stack.isEmpty {
            let char = stack.popFirst()
            switch char {
            case "(":
                score = score * 5 + 1
            case "[":
                score = score * 5 + 2
            case "{":
                score = score * 5 + 3
            case "<":
                score = score * 5 + 4
            default:
                break
            }
        }

        return score
    }
}
