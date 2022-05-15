func readDataSetCount() -> Int {
    Int(readLine()!)!
}

func readEmpty() {
    readLine()!
}

func readDataSet() -> [Int] {
    readLine()!.split(separator: " ").map{ Int($0)! }
}

func parseDataSetToMap(_ dataSet: [Int]) -> [Int: Int] {
    dataSet.reduce(into: [Int: Int]()) { result, value in
        result[value] = (result[value] ?? 0) + 1
    }
}

func handleNextDataSet() {
    readEmpty()
    let dataSet = parseDataSetToMap(readDataSet())
    var sum = 0
    dataSet.forEach { (key: Int, value: Int) in
        let sets = value / 3
        let remain = value % 3
        sum += sets * 2 * key + remain * key
    }
    print(sum)
}

func main() {
    let dataSetCount = readDataSetCount()
    for _ in 0 ..< dataSetCount {
        handleNextDataSet()
    }
}

main()

