typealias Table = [[Int]]

func readDataSetCount() -> Int {
    Int(readLine()!)!
}

func readEmpty() {
    readLine()!
}

func readTableLinesCount() -> Int {
    Int(readLine()!.split(separator: " ")[0])!
}

func readTable(linesCount: Int) -> Table {
    var table = Table()
    for _ in 0 ..< linesCount {
        table.append(readLine()!.split(separator: " ").map{ Int($0)! })
    }
    return table
}

func readClicks() -> [Int] {
    readLine()!.split(separator: " ").map { Int($0)! }
}

func handleNextDataSet() {
    readEmpty()
    let lines = readTableLinesCount()
    var table = readTable(linesCount: lines)
    readEmpty()
    let clicks = readClicks()
    for click in clicks {
        table.sort { row1, row2 in
            row1[click - 1] < row2[click - 1]
        }
    }

    for row in table {
        print(row.map{ "\($0)" }.joined(separator: " "))
    }
    print()
}

func main() {
    let dataSetCount = readDataSetCount()
    for _ in 0 ..< dataSetCount {
        handleNextDataSet()
    }
}

main()

