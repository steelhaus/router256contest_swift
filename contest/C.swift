import Foundation
typealias Table = [[Int]]

func readInt() -> Int {
    Int(readLine()!)!
}

func readLogin() -> String {
    readLine()!
}

func validateLogin(_ login: String) -> Bool {
    guard login.count >= 2 && login.count <= 24 else {
        return false
    }
    let arr = login.map{ $0 }
    guard arr[0] != "-" else {
        return false
    }
    for i in 0 ..< arr.count {
        let e = arr[i]
        if !e.isLowercase && !e.isNumber && e != "-" && e != "_" {
            return false
        }
    }

    return true
}

func handleNextDataSet() {
    let logins = readInt()
    var loginsSet = Set<String>()
    for _ in 0 ..< logins {
        let login = readLogin().lowercased()
        guard validateLogin(login) else {
            print("NO")
            continue
        }
        if loginsSet.contains(login) {
            print("NO")
            continue
        }
        loginsSet.insert(login)
        print("YES")
    }

    print()
}

func main() {
    let dataSetCount = readInt()
    for _ in 0 ..< dataSetCount {
        handleNextDataSet()
    }
}

main()

