import Foundation

extension Trivia {
    init(category: String, type: String, difficulty: String, question: String, correct_answer: String, incorrect_answers: [String]) {
        self.category = category
        self.type = type
        self.difficulty = difficulty
        self.question = question
        self.correct_answer = correct_answer
        self.incorrect_answers = incorrect_answers
    }
}

let SampleTrivias = [
    Trivia(
        category: "Science",
        type: "multiple",
        difficulty: "hard",
        question: "What is the smallest element on the periodic table?",
        correct_answer: "Hydrogen",
        incorrect_answers: ["Oxygen", "Helium", "Carbon"]
    ),
    Trivia(
        category: "Geography",
        type: "multiple",
        difficulty: "easy",
        question: "What is the capital of Canada?",
        correct_answer: "Ottawa",
        incorrect_answers: ["Toronto", "Vancouver", "Montreal"]
    ),
    Trivia(
        category: "Sports",
        type: "multiple",
        difficulty: "easy",
        question: "What is the most-watched sporting event in the world?",
        correct_answer: "The FIFA World Cup",
        incorrect_answers: ["The Super Bowl", "The Olympic Games", "The UEFA Champions League"]
    ),
    Trivia(
        category: "Music",
        type: "multiple",
        difficulty: "medium",
        question: "Which Kpop group is known as the 'Nation's Girl Group' in South Korea?",
        correct_answer: "Girls' Generation",
        incorrect_answers: ["TWICE", "Blackpink", "Mamamoo"]
    ),
    Trivia(
        category: "Gaming",
        type: "boolean",
        difficulty: "easy",
        question: "In the game 'Minecraft', a golden apple can be eaten as food.",
        correct_answer: "True",
        incorrect_answers: ["False"]
    )
]
