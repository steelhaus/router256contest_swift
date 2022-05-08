/// Insertion via bsearch was used to reduce time of searching min remaining time due to reduce total time cost
/// Was kinda lazy to write it by myself. Taken from here:. Pretty easy though.
/// https://stackoverflow.com/questions/26678362/how-do-i-insert-an-element-at-the-correct-position-into-a-sorted-array-in-swift
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
}

class Queue {
    /// Available threads count
    private let threadsLimit: Int
    /// Duration remains for different tasks (tasks order does not matter)
    private var threadsRemains: [Int] = []

    /// Timer of the queue
    var currentTime: Int = 1

    init(threadsLimit: Int) {
        self.threadsLimit = threadsLimit
    }

    // Add task
    func addTask(start: Int, duration: Int) {
        waitUntilReadyToAcceptTaskAt(start)
        threadsRemains.insertViaBSearch(duration) { $0 < $1 }
    }

    /// Wait until at least one thread is free or the task start time comes.
    private func waitUntilReadyToAcceptTaskAt(_ start: Int) {
        let timeBeforeStart = max(start - currentTime, 0)
        let timeBeforeQueueGetsAvailable = threadsRemains.count >= threadsLimit ? threadsRemains[0] : 0
        let timeToWait = max(timeBeforeStart, timeBeforeQueueGetsAvailable)
        if timeToWait > 0 {
            wait(timeToWait)
        }
    }

    private func wait(_ duration: Int) {
        currentTime += duration
        threadsRemains = threadsRemains.map { $0 - duration }
        threadsRemains.removeAll { $0 <= 0 }
    }
}


// MARK: - Parsing

struct Task {
    let start: Int
    let duration: Int
}

struct QueueInfo {
    let threads: Int
    let tasksCount: Int
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

// MARK: - main

func handleNextDataSet() {
    let queueInfo = readQueueInfo()
    let queue = Queue(threadsLimit: queueInfo.threads)

    var endings = Array(repeating: 0, count: queueInfo.tasksCount)
    for idx in 0 ..< queueInfo.tasksCount {
        let task = readNextTask()
//        queue.waitUntilReadyToAcceptTaskAt(task.start)
        queue.addTask(start: task.start, duration: task.duration)
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
