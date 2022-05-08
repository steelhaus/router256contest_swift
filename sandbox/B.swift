class Element: Comparable {
    var value: Int
    init(_ value: Int) {
        self.value = value
    }
    static func < (lhs: Element, rhs: Element) -> Bool {
        lhs.value < rhs.value
    }
    static func == (lhs: Element, rhs: Element) -> Bool {
        lhs.value == rhs.value
    }
}

func readInt() -> Int {
    Int(readLine()!)!
}

func readDataSet() -> [Element] {
    readLine()!.split(separator: " ").map { Element(Int($0)!) }
}

/// Save initial dataSet to enumerate later all elements in the given order.
/// So we have here O(nlogn) performance (cause - sort)
/// And O(2n) -> O(n) memory
func handleNextDataSet() {
    let dataSetInitial = readDataSet()
    let dataSet = dataSetInitial.sorted { $0 > $1 }

    var prevMax = dataSet[0].value
    var order = 1
    dataSet.forEach { data in
        if data.value == prevMax || data.value == prevMax - 1 {
            data.value = order
        } else {
            prevMax = data.value
            order += 1
            data.value = order
        }
    }

    let result = dataSetInitial.map{ "\($0.value)" }
    print(result.joined(separator: " "))
}

func main() {
    let dataSetsCount = readInt()
    for _ in 0 ..< dataSetsCount {
        readInt()
        handleNextDataSet()
    }
}

main()
