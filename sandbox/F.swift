extension Array {
    mutating func insertViaBSearch(_ elem: Element, isOrderedBefore: (Element, Element) -> Bool){
        var lo = 0
        var hi = self.count - 1
        while lo <= hi {
            let mid = (lo + hi)/2
            if isOrderedBefore(self[mid], elem) {
                lo = mid + 1
            } else if isOrderedBefore(elem, self[mid]) {
                hi = mid - 1
            } else {
                insert(elem, at: mid)
                return
            }
        }
        insert(elem, at: lo)
    }

    func object(at index: Int) -> Element? {
        guard index >= 0, index < count else { return nil }
        return self[index]
    }
}

struct FieldInfo {
    let rows: Int
    let columns: Int
}

func readInt() -> Int {
    Int(readLine()!)!
}

func readFieldInfo() -> FieldInfo {
    let rawInfo = readLine()!.split(separator: " ")
    return FieldInfo(rows: Int(rawInfo[0])!, columns: Int(rawInfo[1])!)
}

func readFieldLine() -> String {
    readLine()!
}

func parseFieldLine(_ line: String, into columnsMap: inout [Int: Int], with rowsMap: inout [Int: [Int]]) {
    line.enumerated().forEach { offset, char in
        if char == "*" {
            let height = columnsMap[offset]! + 1
            rowsMap[height - 1]!.insertViaBSearch(offset) { $0 < $1 }
            columnsMap[offset] = columnsMap[offset]! + 1
        }
    }
}

func processNextDataSet() {
    let fieldInfo = readFieldInfo()
    var columnsMap = (0 ..< fieldInfo.columns).reduce(into: [Int: Int]()) { $0[$1] = 0 }
    var rowsMap = (0 ..< fieldInfo.rows).reduce(into: [Int: [Int]]()) { $0[$1] = [] }
    for _ in 0 ..< fieldInfo.rows {
        parseFieldLine(readFieldLine(), into: &columnsMap, with: &rowsMap)
    }

    for row in stride(from: fieldInfo.rows - 1, through: 0, by: -1) {
        var currentIndex = 0
        var currentIndexBlock = 0
        var result = ""
        var isWater: Bool = false

        while (true) {
            guard currentIndex < fieldInfo.columns else { break }
            if let nextBlock = rowsMap[row]?.object(at: currentIndexBlock) {
                result += String(repeating: isWater ? "~" : ".", count: nextBlock - currentIndex)
                result += "*"
                currentIndexBlock += 1
                currentIndex = nextBlock + 1
                isWater = true
            } else {
                let ct = fieldInfo.columns - currentIndex
                result += String(repeating: ".", count: ct)
                break
            }
        }

        print(result)
    }
    print()
}

func main() {
    let dataCount = readInt()
    for _ in 0 ..< dataCount {
        processNextDataSet()
    }
}

main()
