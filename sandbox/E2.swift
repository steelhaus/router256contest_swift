struct Task {
    let start: Int
    let duration: Int
}

struct QueueInfo {
    let threads: Int
    let tasksCount: Int
}

class Queue {
    private let threadsLimit: Int

    /// Minimum duration of all added tasks
    private var minDuration: Int = 0
    /// Duration remains for different tasks (tasks order does not matter)
    private var threadsRemains: [Int] = []

    var currentTime: Int = 1

    init(threadsLimit: Int) {
        self.threadsLimit = threadsLimit
    }

    func waitUntilReadyToAcceptTaskAt(_ start: Int) {
        if threadsRemains.count >= threadsLimit {
            wait(minDuration)
        }
        if start > currentTime {
            wait(start - currentTime)
        }
    }

    func addTask(duration: Int) {
        minDuration = minDuration == 0 ? duration : min(minDuration, duration)
        threadsRemains.append(duration)
    }

    private func wait(_ duration: Int) {
        currentTime += duration
        threadsRemains = threadsRemains.map { $0 - duration }
        threadsRemains.removeAll { $0 <= 0 }
        minDuration = threadsRemains.min() ?? 0
    }
}

func readInt() -> Int {
    Int(readLine()!)!
}

func readEmpty() {
    readLine()
}

func readQueueInfo() -> QueueInfo {
    let rawLine = readLine()!.split(separator: " ")
    return QueueInfo(threads: Int(rawLine[0])!, tasksCount: Int(rawLine[1])!)
}

func readNextTask() -> Task {
    let rawLine = readLine()!.split(separator: " ")
    return Task(start: Int(rawLine[0])!, duration: Int(rawLine[1])!)
}


func handleNextDataSet() {
    let queueInfo = readQueueInfo()
    let queue = Queue(threadsLimit: queueInfo.threads)

    var endings = Array(repeating: 0, count: queueInfo.tasksCount)
    for idx in 0 ..< queueInfo.tasksCount {
        let task = readNextTask()
        queue.waitUntilReadyToAcceptTaskAt(task.start)
        queue.addTask(duration: task.duration)
        endings[idx] = queue.currentTime + task.duration
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
