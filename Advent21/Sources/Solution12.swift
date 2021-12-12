import AdventUtilities
import Collections
import Foundation

public enum Solution12: Solution {
    public static var title = "--- Day 12: Passage Pathing ---"

    public static func part1(_ input: String) -> String {
        let graph = parseInput(input)
        return String(describing: countPaths(graph))
    }

    public static func part2(_ input: String) -> String {
        let graph = parseInput(input)
        return String(describing: countPaths(graph, allowLoop: true))
    }
}

extension Solution12 {
    enum Cave: Hashable {
        case start
        case large(String)
        case small(String)
        case end

        init(_ string: String) {
            if string == "start" {
                self = .start
            } else if string == "end" {
                self = .end
            } else if string.lowercased() == string {
                self = .small(string)
            } else {
                self = .large(string)
            }
        }
    }

    static func parseInput(_ input: String) -> [Cave: [Cave]] {
        var adjacency = [Cave: [Cave]]()
        for pair in input.lines.map(parseLine) {
            adjacency[pair.0, default: []].append(pair.1)
            adjacency[pair.1, default: []].append(pair.0)
        }

        return adjacency
    }

    static func parseLine(_ line: String) -> (Cave, Cave) {
        let parts = line.split(separator: "-").map(String.init)
        return (Cave(parts[0]), Cave(parts[1]))
    }

    static func countPaths(_ graph: [Cave: [Cave]], allowLoop: Bool = false) -> Int {
        let node = (Cave.start, Set<Cave>([.start]), false)
        var count = 0
        var queue = Deque.init([node])
        while !queue.isEmpty {
            guard
                let (current, smallVisited, hasLooped) = queue.popFirst()
            else {
                fatalError("Already checked it isn't empty")
            }
            if current == .end {
                count += 1
                continue
            }
            for adjacent in graph[current] ?? [] {
                if !smallVisited.contains(adjacent) {
                    var smallVisited = smallVisited
                    if case Cave.small(_) = adjacent {
                        smallVisited.insert(adjacent)
                    }
                    queue.append((adjacent, smallVisited, hasLooped))
                } else if allowLoop &&
                            !hasLooped &&
                            smallVisited.contains(adjacent) &&
                            ![Cave.start, .end].contains(adjacent) {
                    queue.append((adjacent, smallVisited, true))
                }
            }
        }

        return count
    }
}
