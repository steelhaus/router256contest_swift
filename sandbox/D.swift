extension StringProtocol {
    subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
}

func readWord() -> String {
    readLine()!
}

func main() {
    let originalWord = readWord()
    let guessWord = readWord()

    if originalWord == guessWord {
        let result = String(repeating: "G", count: guessWord.count)
        print(result)
        return
    }

    var charMap: [Character: Int] = ["A": 0, "B": 0, "C": 0, "D": 0, "E": 0, "F": 0, "G": 0, "H": 0, "I": 0, "J": 0, "K": 0, "L": 0, "M": 0, "N": 0, "O": 0, "P": 0, "Q": 0, "R": 0, "S": 0, "T": 0, "U": 0, "V": 0, "W": 0, "X": 0, "Y": 0, "Z": 0]
    var filled: [Int: Bool] = [:]
    originalWord.enumerated().forEach { index, char in
        if char == guessWord[index] {
            filled[index] = true
        } else {
            charMap[char] = charMap[char]! + 1
        }
    }
    if filled.count == guessWord.count {
        let result = String(repeating: "G", count: guessWord.count)
        print(result)
        return
    }

    var result = ""
    guessWord.enumerated().forEach { index, char in
        if filled[index] != nil {
            result += "G"
        } else {
            let availableCount = charMap[char]!
            if availableCount > 0 {
                result += "Y"
                charMap[char] = availableCount - 1
            } else {
                result += "."
            }
        }
    }
    print(result)
}

main()
