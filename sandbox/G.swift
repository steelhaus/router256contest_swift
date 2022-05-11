typealias Row = [Int: User]
typealias Field = [Int: Row]

struct WinningSet {
    struct Pair {
        let row: Int
        let column: Int
    }

    let pairs: [Pair]

    func winnerIn(field: Field) -> User? {
        var currentWinner: User?
        for pair in pairs {
            let user = field[pair.row]![pair.column]
            if user == .empty || (user != currentWinner && currentWinner != nil) {
                return nil
            } else {
                currentWinner = user
            }
        }
        return currentWinner!
    }

    init(_ a: Int, _ b: Int, _ c: Int, _ d: Int, _ e: Int, _ f: Int) {
        pairs = [
            .init(row: a, column: b),
            .init(row: c, column: d),
            .init(row: e, column: f)
        ]
    }

    static func winningSets() -> [WinningSet] {
        [
            .init(0, 0, 0, 1, 0, 2),
            .init(1, 0, 1, 1, 1, 2),
            .init(2, 0, 2, 1, 2, 2),
            .init(0, 0, 1, 0, 2, 0),
            .init(0, 1, 1, 1, 2, 1),
            .init(0, 2, 1, 2, 2, 2),
            .init(0, 0, 1, 1, 2, 2),
            .init(0, 2, 1, 1, 2, 0)
        ]
    }
}

enum User {
    case x
    case o
    case empty
}

func readInt() -> Int {
    Int(readLine()!)!
}

func readEmpty() {
    readLine()
}

func readLineInfo(xCount: inout Int, oCount: inout Int) -> Row {
    readLine()!.enumerated().reduce(into: Row()) { result, en in
        switch en.element {
            case "X":
                result[en.offset] = .x
                xCount += 1
            case "0":
                result[en.offset] = .o
                oCount += 1
            default: result[en.offset] = .empty
        }
    }
}

func processNextDataSet() -> Bool {
    var xCount = 0
    var oCount = 0
    let field = (0 ..< 3).reduce(into: Field()) { result, idx in
        result[idx] = readLineInfo(xCount: &xCount, oCount: &oCount)
    }
    if xCount > oCount + 1 || oCount > xCount {
        return false
    }
    var winner: User?
    let winningSets = WinningSet.winningSets()
    for winningSet in winningSets {
        let newWinner = winningSet.winnerIn(field: field)
        if winner != nil && newWinner != nil {
            return false
        } else {
            winner = newWinner ?? winner
        }
    }

    if (winner == .o && oCount != xCount) || (winner == .x && oCount != xCount - 1) {
        return false
    }

    return true
}

func main() {
    let dataSets = readInt()
    for _ in 0 ..< dataSets {
        readEmpty()
        switch processNextDataSet() {
            case true:
                print("YES")
            case false:
                print("NO")
        }
    }
}



main()

