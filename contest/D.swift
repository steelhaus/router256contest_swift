import Foundation

typealias PhoneCall = (name: String, phone: String)

class User {
    let name: String
    var phonesSet = Set<String>()
    var phones: [String] = []

    init(name: String) {
        self.name = name
    }

    func addPhone(_ phone: String) {
        phones.append(phone)
        phonesSet.insert(phone)
    }

    func getUserPhones() -> String {
        let count = min(phonesSet.count, 5)
        var phonesArr: [String] = []
        for i in stride(from: phones.count - 1, to: -1, by: -1) {
            let phone = phones[i]
            if phonesSet.contains(phone) {
                phonesSet.remove(phone)
                phonesArr.append(phone)
            }
            if phonesArr.count == 5 { break }
        }
        let phones = phonesArr.joined(separator: " ")
        return "\(name): \(count) \(phones)"
    }
}

func readInt() -> Int {
    Int(readLine()!)!
}

func readNextUser() -> PhoneCall {
    let line = readLine()!.split(separator: " ")
    return (String(line[0]), String(line[1]))
}

func handleNextDataSet() {
    var usersMap: [String: User] = [:]
    var users: [User] = []
    let calls = readInt()
    for _ in 0 ..< calls {
        let call = readNextUser()
        if  usersMap[call.name] == nil {
            let user = User(name: call.name)
            users.append(user)
            usersMap[call.name] = user
        }
        usersMap[call.name]?.addPhone(call.phone)
    }

    let sortedUsers = users.sorted { $0.name < $1.name }
    sortedUsers.forEach {
        print($0.getUserPhones())
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
