import Foundation

typealias FieldInfo = (cols: Int, rows: Int)

enum Position {
    case lu // left up angle (1)
    case ru // right up angle (2)
    case ld // left down angle (3)
    case rd // right down angle (4)
}

enum Cell {
    case ship
    case empty

    static func fromChar(_ char: String.Element) -> Cell {
        char == "*" ? .ship : .empty
    }
}

class Ship {
    var width: Int = 0
    var height: Int = 0
    var cornerIndex: Int = 0

    var checkColLeft: Int = 0
    var checkColRight: Int = 0

    var checkForEmpty: Bool = false

    func updateCheckIndexes() ->
}

struct ShipSubline {
    let startIndex: Int
    let count: Int
}

func readInt() -> Int {
    Int(readLine()!)!
}

func readEmpty() {
    readLine()
}

func readFieldInfo() -> FieldInfo {
    let line = readLine()!.split(separator: " ").map{ Int($0)! }
    return (line[0], line[1])
}

func readFieldLine() -> [ShipSubline]? {
    let line = readLine()!
    var type: Cell = .empty
    var sublineIndex = 0
    var sublineCount = 0
    var sublines: [ShipSubline] = []

    for (offset, char) in line.enumerated() {
        let newType = Cell.fromChar(char)
        if newType != type {
            if type == .ship {
                sublines.append(.init(startIndex: sublineIndex, count: sublineCount))
            }
            type = newType
            sublineIndex = offset
            sublineCount = 1
        } else {
            sublineCount += 1
            if sublineCount > 5 && type == .ship {
                return nil
            }
        }
    }
    if type == .ship {
        sublines.append(.init(startIndex: sublineIndex, count: sublineCount))
    }
    return sublines
}

func handleNextDataSet() -> [Int]? {
    let fieldInfo = readFieldInfo()
    var ships: [Ship] = []
    for row in 0 ..< fieldInfo.rows {
        guard let fieldLine = readFieldLine() else { return nil }
        for shipSubline in fieldLine {
            let ship = Ship()
            ship.height = 1
            ship.width = shipSubline.count
            ship.cornerIndex = shipSubline.startIndex
        }
    }

    return nil
}

func main() {
    let dataSetCount = readInt()
    for _ in 0 ..< dataSetCount {
        handleNextDataSet()
    }
}

main()

