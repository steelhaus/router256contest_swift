func readInt() -> Int {
    Int(readLine()!)!
}

func readEmpty() {
    readLine()
}

func readLine() -> [Int] {
    readLine()!.split(separator: " ").map{ Int($0)! }
}

func printReversed(line: [Int]) {
    print(line.map{ "\($0)" }.joined(separator: " "))
}

func getReversed(from line: [Int], zeroIndex: Int) -> [Int]? {
    var reversed = Array(repeating: 0, count: line.count + 1)
    for i in zeroIndex + 1 ..< reversed.count {
        let newValue = reversed[i - 1] + line[i - 1]
        if newValue < 0 { return nil }
        reversed[i] = newValue
    }
    for i in stride(from: zeroIndex - 1, to: -1, by: -1) {
        let newValue = reversed[i + 1] - line[i]
        if newValue < 0 { return nil }
        reversed[i] = newValue
    }
    return reversed
}

func main() {
    readEmpty()
    let line = readLine()
    var isRaising = true
    for idx in 0 ..< line.count {
        let item = line[idx]
        if item >= 0 {
            if isRaising {
                if let reversed = getReversed(from: line, zeroIndex: idx) {
                    printReversed(line: reversed)
                    return
                }
            }
            continue
        } else {
            if idx == line.count - 1 {
                if let reversed = getReversed(from: line, zeroIndex: idx + 1) {
                    printReversed(line: reversed)
                    return
                }
            } else {
                isRaising = true
            }
        }
    }
}

main()

