import Foundation

var seats: [Bool] = []
var coupes: [Bool] = []

enum Request {
    case purchase(Int)
    case cancellation(Int)
    case coupe
}

func readDataSetCount() -> Int {
    Int(readLine()!)!
}

func readEmpty() {
    readLine()
}

class OrderedCoupeLine {
    var startIndex: Int = 0
    var count: Int = 0
}

func readDataSetInfo() -> (coupeCount: Int, requestsCount: Int) {
    let line = readLine()!.split(separator: " ").map{ Int($0)! }
    return (line[0], line[1])
}

func getNextRequest() -> Request {
    let line = readLine()!.split(separator: " ").map{ Int($0)! }
    if line[0] == 1 {
        return .purchase(line[1] - 1)
    }
    if line[0] == 2 {
        return .cancellation(line[1] - 1)
    }
    return .coupe
}

func orderSeat(_ seat: Int) -> Bool {
    guard seats[seat] != true else { return false }
    seats[seat] = true
    let coupeIdx = seat / 2
    coupes[coupeIdx] = true
    return true
}

func cancelSeat(_ seat: Int) -> Bool {
    guard seats[seat] != false else { return false }
    seats[seat] = false
    let coupeIdx = seat / 2
    let coupeX2 = coupeIdx * 2
    if seats[coupeX2] == false && seats[coupeX2 + 1] == false {
        coupes[coupeIdx] = false
    }
    return true
}

func orderCoupe() -> (s1: Int, s2: Int)? {
    if let idx = coupes.firstIndex(where: { !$0 }) {
        coupes[idx] = true
        let s1 = idx * 2
        let s2 = idx * 2 + 1
        seats[s1] = true
        seats[s2] = true
        return (s1 + 1, s2 + 1)
    } else {
        return nil
    }
}

func handleNextDataSet() {
    readEmpty()
    let info = readDataSetInfo()
    seats = [Bool].init(repeating: false, count: info.coupeCount * 2)
    coupes = [Bool].init(repeating: false, count: info.coupeCount)
    for _ in 0 ..< info.requestsCount {
        let request = getNextRequest()
        switch request {
            case .purchase(let seat):
                printBoolResult(orderSeat(seat))
            case .cancellation(let seat):
                printBoolResult(cancelSeat(seat))
            case .coupe:
                printReserveResult(orderCoupe())
                break
        }
    }
    print()
}

func printBoolResult(_ value: Bool) {
    switch value {
        case true: print("SUCCESS")
        case false: print("FAIL")
    }
}

func printReserveResult(_ value: (s1: Int, s2: Int)?) {
    guard let value = value else {
        print("FAIL")
        return
    }
    print("SUCCESS \(value.s1)-\(value.s2)")
}

func main() {
    let dataSetCount = readDataSetCount()
    for _ in 0 ..< dataSetCount {
        handleNextDataSet()
    }
}

main()
