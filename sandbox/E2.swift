extension Array {
    func insertionIndexOf(_ elem: Element, isOrderedBefore: (Element, Element) -> Bool) -> Int {
        var lo = 0
        var hi = self.count - 1
        while lo <= hi {
            let mid = (lo + hi)/2
            if isOrderedBefore(self[mid], elem) {
                lo = mid + 1
            } else if isOrderedBefore(elem, self[mid]) {
                hi = mid - 1
            } else {
                return mid // found at position mid
            }
        }
        return lo // not found, would be inserted at position lo
    }
}

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
//    private var minDuration: Int = 0
    /// Duration remains for different tasks (tasks order does not matter)
    private var threadsRemains: [Int] = []

    var currentTime: Int = 1

    init(threadsLimit: Int) {
        self.threadsLimit = threadsLimit
    }

    func waitUntilReadyToAcceptTaskAt(_ start: Int) {
        let timeBeforeStart = max(start - currentTime, 0)
        let timeBeforeQueueGetsAvailable = threadsRemains.count >= threadsLimit ? threadsRemains[0] : 0
        let timeToWait = max(timeBeforeStart, timeBeforeQueueGetsAvailable)
        if timeToWait > 0 {
            wait(timeToWait)
        }
//        let timeToWait = max(start - currentTime, 0)
//        if threadsRemains.count >= threadsLimit {
//            wait(threadsRemains[0])
//        }
//        if start > currentTime {
//            wait(start - currentTime)
//        }
    }

    func addTask(duration: Int) {
        let index = threadsRemains.insertionIndexOf(duration) { $0 < $1 }
        threadsRemains.insert(duration, at: index)
//        minDuration = minDuration == 0 ? duration : min(minDuration, duration)
////        minDuration = min(minDuration, duration)
//        threadsRemains.append(duration)
    }

    private func wait(_ duration: Int) {
//        print("------")
//        print("wait for: \(duration)")
//        print(threadsRemains)
        currentTime += duration
        threadsRemains = threadsRemains.map { $0 - duration }
        threadsRemains.removeAll { $0 <= 0 }
//        minDuration = threadsRemains.min() ?? 0
//        print("min duration remains: \(minDuration)")
//        print(threadsRemains)
    }
}

class Data {

    static var currentIndex: Int = 0
    let queueInfo = QueueInfo(threads: 1, tasksCount: 5)
    let tasks: [Task] = [
        // Set 1
//        .init(start: 1, duration: 10),
//        .init(start: 2, duration: 9),
//        .init(start: 3, duration: 8),
//        .init(start: 4, duration: 7),
//        .init(start: 5, duration: 6)

        // Set 2
        .init(start: 1, duration: 10),
        .init(start: 2, duration: 9),
        .init(start: 3, duration: 8),
        .init(start: 4, duration: 7),
        .init(start: 5, duration: 6)
    ]

    func getNextTask() -> Task {
        let task = tasks[Data.currentIndex]
        Data.currentIndex += 1
        return task
    }

}

let data = Data()

func readInt() -> Int {
//    return 1
    Int(readLine()!)!
}

func readEmpty() {
    readLine()
}

func readQueueInfo() -> QueueInfo {
//    data.queueInfo
    let rawLine = readLine()!.split(separator: " ")
    return QueueInfo(threads: Int(rawLine[0])!, tasksCount: Int(rawLine[1])!)
}

func readNextTask() -> Task {
//    data.getNextTask()
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
