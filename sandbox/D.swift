func readWord() -> String {
    readLine()!
}

func main() {
    let originalWordRaw = readWord()

    var charMap: [Character: Int] = ["A": 0, "B": 0, "C": 0, "D": 0, "E": 0, "F": 0, "G": 0, "H": 0, "I": 0, "J": 0, "K": 0, "L": 0, "M": 0, "N": 0, "O": 0, "P": 0, "Q": 0, "R": 0, "S": 0, "T": 0, "U": 0, "V": 0, "W": 0, "X": 0, "Y": 0, "Z": 0]
    var guessWord = readWord().map { $0 }
    let originalWord: [String.Element] = originalWordRaw.enumerated().map { index, char in
        if char != guessWord[index] {
            charMap[char] = charMap[char]! + 1
        }
        return char
    }
    for i in 0 ..< guessWord.count {
        if guessWord[i] == originalWord[i] {
            guessWord[i] = "G"
        } else {
            let char = guessWord[i]
            let availableCount = charMap[char]!
            if availableCount > 0 {
                guessWord[i] = "Y"
                charMap[char] = availableCount - 1
            } else {
                guessWord[i] = "."
            }
        }
    }
    let result = guessWord.map{ "\($0)" }.joined(separator: "")
    print(result)
}

main()
