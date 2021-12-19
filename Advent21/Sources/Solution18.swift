import AdventUtilities
import Collections
import Foundation

public enum Solution18: Solution {
    public static var title = ""

    public static func part1(_ input: String) -> String {
        let sn = input.lines.map(parseSnailNumber)
        print(sn[0])
        return "Not Solved Yet"
    }

    public static func part2(_ input: String) -> String {
        "Not Solved Yet"
    }
}

extension Solution18 {
    class SnailNumber {
        enum Element {
            case value(Int)
            case node(SnailNumber)
        }

        var left: Element
        var right: SnailNumber?
        var parent: SnailNumber?

        required init(_ left: Element, right: SnailNumber? = nil, parent: SnailNumber? = nil) {
            self.left = left
            self.right = right
            self.parent = parent
        }

        convenience init(_ int: Int) {
            self.init(.value(int))
        }

        convenience init(left: SnailNumber, right: SnailNumber) {
            self.init(.node(left), right: right)
        }

        func append(_ rhs: SnailNumber) -> SnailNumber {
            let left = self
            let right = rhs
            let newNumber = SnailNumber(left: self, right: rhs)
            left.parent = newNumber
            right.parent = newNumber

            return newNumber
        }

        var height: Int {
            switch left {
            case .value(_):
                return 1
            case .node(let sn):
                return 1 + max(sn.height, right?.height ?? 0)
            }
        }
    }
}

extension Solution18 {
    static func parseSnailNumber(_ string: String) -> SnailNumber {
        var snailNumberQueue = Deque<SnailNumber>()
        var chars = string[...]
        var c = chars.popFirst()

        while c != nil {
            switch c {
            case let n? where n.isNumber:
                let sn = SnailNumber(n.wholeNumberValue!)
                snailNumberQueue.append(sn)
            case "]":
                guard let right = snailNumberQueue.popLast(),
                      let left = snailNumberQueue.popLast()
                else { fatalError("Mis-matched input") }
                let new = left.append(right)
                snailNumberQueue.append(new)
            default:
                break
            }

            c = chars.popFirst()
        }

        return snailNumberQueue.popLast()!
    }
}
