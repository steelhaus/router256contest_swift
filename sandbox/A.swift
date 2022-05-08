func readInt() -> Int {
    Int(readLine()!)!
}

func readIntSet() -> [Int] {
    readLine()!.split(separator: " ").map { Int($0)! }
}

func main() {
    let dataCount = readInt()
    for _ in 0 ..< dataCount {
        let data = readIntSet()
        print(data[0] + data[1])
    }
}

main()
