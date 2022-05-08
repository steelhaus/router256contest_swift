struct Task {
    let start: Int
    let duration: Int
}

func readInt() -> Int {
    Int(readLine()!)!
}

func readEmpty() {
    readLine()
}

func readNextTask() -> Task {
    let rawLine = readLine()!.split(separator: " ")
    return Task(start: Int(rawLine[0])!, duration: Int(rawLine[1])!)
}


func handleNextDataSet() {
    let tasksCount = readInt()
    var endings = Array(repeating: 0, count: tasksCount)
    var currentTime = 0
    for idx in 0 ..< tasksCount {
        let task = readNextTask()
        if currentTime < task.start {
            currentTime = task.start
        }
        currentTime += task.duration
        endings[idx] = currentTime
    }

    let result = endings.map(String.init).joined(separator: " ")
    print(result)
}

func main() {
    let dataSetsCount = readInt()
    for _ in 0 ..< dataSetsCount {
        readEmpty()
        handleNextDataSet()
    }
}

main()
