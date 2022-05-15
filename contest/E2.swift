import Foundation

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

struct MockData {
    static private var currentRow = 0
    static private var rows: [String] {
        [
            "3",
            "3",
            "3",
            "3"
        ]
    }

    static var rowsCount: Int { 6 }
    static func getNextRow() -> String {
        let line = rows[currentRow]
        currentRow += 1
        return line
    }
}

class OrderedCoupeLine {
    var startIndex: Int = 0
    var count: Int = 0
}

var seats: [Bool] = []
var coupes: [Bool] = []
var coupesCount: Int = 0
var orderedCoupeLines: [OrderedCoupeLine] = []

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
    makeCoupeFilled(coupeIdx: coupeIdx)
    return true
}

func cancelSeat(_ seat: Int) -> Bool {
    guard seats[seat] != false else { return false }
    seats[seat] = false
    let coupeIdx = seat / 2
    let coupeX2 = coupeIdx * 2
    if seats[coupeX2] == false && seats[coupeX2 + 1] == false {
        makeCoupeEmpty(coupeIdx: coupeIdx)
    }
    return true
}

func orderCoupe() -> (s1: Int, s2: Int)? {
    if let idx = findFirstEmptyCoupe() {
        makeCoupeFilled(coupeIdx: idx)
        let s1 = idx * 2
        let s2 = idx * 2 + 1
        seats[s1] = true
        seats[s2] = true
        return (s1 + 1, s2 + 1)
    } else {
        return nil
    }
}

func makeCoupeFilled(coupeIdx: Int) {
    guard coupes[coupeIdx] != true else { return }
    coupes[coupeIdx] = true
    if coupeIdx > 0 && coupeIdx < coupesCount - 1 && coupes[coupeIdx - 1] && coupes[coupeIdx + 1] {
        let prevOrderIndex = orderedCoupeLines.firstIndex { $0.startIndex + $0.count == coupeIdx }!
        let nextOrderIndex = orderedCoupeLines.firstIndex { $0.startIndex == coupeIdx + 1 }!
        orderedCoupeLines[prevOrderIndex].count = orderedCoupeLines[prevOrderIndex].count + orderedCoupeLines[nextOrderIndex].count + 1
        orderedCoupeLines.remove(at: nextOrderIndex)
        // Collapse orders into 1
    } else if coupeIdx > 0 && coupes[coupeIdx - 1] {
        // Collapse with previous order
        let orderIndex = orderedCoupeLines.firstIndex { $0.startIndex + $0.count == coupeIdx }!
        orderedCoupeLines[orderIndex].count += 1
    } else if coupeIdx < coupesCount - 1 && coupes[coupeIdx + 1] {
        let orderIndex = orderedCoupeLines.firstIndex { $0.startIndex == coupeIdx + 1 }!
        orderedCoupeLines[orderIndex].count += 1
        orderedCoupeLines[orderIndex].startIndex -= 1
        // Collapse with next order
    } else {
        let newOrder = OrderedCoupeLine()
        newOrder.startIndex = coupeIdx
        newOrder.count = 1
        orderedCoupeLines.insertViaBSearch(newOrder) { $0.startIndex < $1.startIndex }
    }
}

func makeCoupeEmpty(coupeIdx: Int) {
    guard coupes[coupeIdx] != false else { return }
    coupes[coupeIdx] = false
    let orderIndex = orderedCoupeLines.firstIndex { order in
        coupeIdx >= order.startIndex && coupeIdx < order.startIndex + order.count
    }!
    if orderedCoupeLines[orderIndex].count == 1 {
        orderedCoupeLines.remove(at: orderIndex)
    } else if orderedCoupeLines[orderIndex].startIndex == coupeIdx {
        orderedCoupeLines[orderIndex].startIndex += 1
        orderedCoupeLines[orderIndex].count -= 1
    } else if orderedCoupeLines[orderIndex].startIndex + orderedCoupeLines[orderIndex].count - 1 == coupeIdx {
        orderedCoupeLines[orderIndex].count -= 1
    } else {
        let nextCount = orderedCoupeLines[orderIndex].startIndex + orderedCoupeLines[orderIndex].count - 1 - coupeIdx
        let prevCount = orderedCoupeLines[orderIndex].count - nextCount - 1
        orderedCoupeLines[orderIndex].count = prevCount
        let newOrder = OrderedCoupeLine()
        newOrder.count = nextCount
        newOrder.startIndex = coupeIdx + 1
        orderedCoupeLines.insert(newOrder, at: orderIndex + 1)
    }
}

func findFirstEmptyCoupe() -> Int? {
    var firstCoupe = 0
    for order in orderedCoupeLines {
        if order.startIndex == firstCoupe {
            firstCoupe = order.startIndex + order.count
            if firstCoupe >= coupesCount { return nil }
        } else {
            return firstCoupe
        }
    }
    return firstCoupe
}

func handleNextDataSet() {
    readEmpty()
    let info = readDataSetInfo()
    coupesCount = info.coupeCount
    orderedCoupeLines.removeAll()
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
