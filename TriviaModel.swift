import Foundation

struct Trivia: Decodable {
    var category: String
    var type: String
    var difficulty: String
    var question: String
    var correct_answer: String
    var incorrect_answers: [String]
    
    init() {
        category = "Geography"
        type = "multiple"
        difficulty = ""
        question = "What is the capital of California?"
        correct_answer = "Sacramento"
        incorrect_answers = ["San Diego", "Los Angeles", "Irvine"]
    }
    
    func getAnswers() -> [String] {
        if type == "boolean" { return ["True", "False"] }
        return (incorrect_answers + [correct_answer]).shuffled()
    }
}
