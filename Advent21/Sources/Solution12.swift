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
        return String(describing: countPathsWithSingleLoop(graph))
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

    static func countPaths(_ graph: [Cave: [Cave]]) -> Int {
        let node = (Cave.start, Set<Cave>([.start]))
        var count = 0
        var queue = Deque.init([node])
        while !queue.isEmpty {
//            print("Top of while:\n\(queue)")
            guard let (current, visited) = queue.popFirst() else { fatalError("Already checked it isn't empty") }
            if current == .end {
                count += 1
                continue
            }
            for adjacent in graph[current] ?? [] {
                if !visited.contains(adjacent) {
                    var v = visited
                    if case Cave.small(_) = adjacent {
                        v.insert(adjacent)
                    }
                    queue.append((adjacent, v))
//                    print("Appended:\n\(queue)")
                }
            }
        }

        return count
    }

    static func countPathsWithSingleLoop(_ graph: [Cave: [Cave]]) -> Int {
        let node = (Cave.start, Set<Cave>([.start]), false)
        var count = 0
        var queue = Deque.init([node])
        while !queue.isEmpty {
            //            print("Top of while:\n\(queue)")
            guard let (current, visited, hasLooped) = queue.popFirst() else { fatalError("Already checked it isn't empty") }
            if current == .end {
                count += 1
                continue
            }
            for adjacent in graph[current] ?? [] {
                if !visited.contains(adjacent) {
                    var v = visited
                    if case Cave.small(_) = adjacent {
                        v.insert(adjacent)
                    }
                    queue.append((adjacent, v, hasLooped))
                    //                    print("Appended:\n\(queue)")
                } else if visited.contains(adjacent) && ![Cave.start, .end].contains(adjacent) && !hasLooped {
                    queue.append((adjacent, visited, true))
                }
            }
        }

        return count
    }
}
