//
//  TriviaGame.swift
//  SimpleTriviaQuiz
//
//  Created by Neal Archival on 3/28/23.
//

import SwiftUI

struct Trivia: Decodable {
    var category: String
    var type: String // Boolean / Multiple
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
    
    mutating func removePercentEncoding() {
        question = question.removingPercentEncoding!
        correct_answer = correct_answer.removingPercentEncoding!
        for i in 0..<incorrect_answers.count {
            incorrect_answers[i] = incorrect_answers[i].removingPercentEncoding!
        }
    }
    
}

struct APIResponse: Decodable {
    var response_code: Int
    var results: [Trivia]?
}

func fetchTriviaData() async -> [Trivia] {
    let triviaURL = URL(string: "https://opentdb.com/api.php?amount=5&category=9&encode=url3986")!
    var httpRequest = URLRequest(url: triviaURL)
    httpRequest.httpMethod = "GET"
    do {
        let (responseData, _) = try await URLSession.shared.data(for: httpRequest)
        var decodedData = try JSONDecoder().decode(APIResponse.self, from: responseData)
        return decodedData.results ?? []
    } catch let error {
        print(error.localizedDescription)
        return []
    }
}

struct TriviaGame: View {
    @State var triviaData: [Trivia] = []
    @State var isComplete: Bool = false
    @State var correctCount: Int = 0
    @State var currentQuestion: Int = 0
    @State var shuffledAnswers: [String] = []
    @State var answerChosen: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            if triviaData.count == 0 {
                Text("Loading...")
            } else if currentQuestion >= triviaData.count { // We have reach the maximum
                ScoreView()
            } else {
                TriviaView()
            }
        } // VStack
        .padding([.leading, .trailing])
        .onAppear {
            Task {
                triviaData = await fetchTriviaData()
                for i in 0..<triviaData.count {
                    triviaData[i].removePercentEncoding()
                }
                shuffleAnswers()
            }
        } // .onAppear
        .onChange(of: currentQuestion) { _ in
            shuffleAnswers()
        }
    } // body
    
    @ViewBuilder
    func ScoreView() -> some View {
        VStack(spacing: 20) {
            Text("You scored: \(correctCount)/\(triviaData.count)")
            Button(action: { reset() }) {
                Text("Retry")
            } // Button
            Button(action: { dismiss() }) {
                Text("Go back")
            } // Button
        }
        .font(.system(size: 24, weight: .regular))
    }
    
    @ViewBuilder
    func TriviaView() -> some View {
        HStack {
            Text("\(triviaData[currentQuestion].question)")
                .font(.system(size: 28, weight: .medium))
            Spacer()
        } // HStack
        VStack(spacing: 20) {
            ForEach(shuffledAnswers, id: \.self) { answer in
                Button(action: { answerClicked(buttonText: answer) }) {
                    Text("\(answer)")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(Color.black)
                        .frame(maxWidth: .infinity, maxHeight: 65)
                        .background(isComplete && answer == triviaData[currentQuestion].correct_answer
                                    ? Color.green
                                    : isComplete && answer != triviaData[currentQuestion].correct_answer && answerChosen == answer
                                    ? Color.red.opacity(0.8)
                                    : Color.white)
                        .cornerRadius(12)
                        .overlay(alignment: .center) {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.black, lineWidth: 1)
                        }
                } // Button
            } // ForEach
            Spacer()
        } // VStack
        Button(action: {
            currentQuestion += 1
            isComplete = false
        }) {
            Text("Next")
                .font(.system(size: 26, weight: .medium))
                .foregroundColor(Color.white)
                .frame(width: 180, height: 60)
                .background(Color.blue)
                .cornerRadius(12)
        } // Button
        .disabled(!isComplete)
    }
    
    func answerClicked(buttonText: String) {
        if isComplete { return } // Do not allow re-answering
        isComplete = true
        answerChosen = buttonText
        if triviaData[currentQuestion].correct_answer == answerChosen {
            correctCount += 1
        }
    }
    
    func reset() {
        isComplete = false
        currentQuestion = 0
        correctCount = 0
        answerChosen = ""
    }
    
    func shuffleAnswers() {
        if currentQuestion >= triviaData.count { return }
        if triviaData[currentQuestion].type == "boolean" {
            shuffledAnswers = ["True", "False"]
            return
        }
        shuffledAnswers = triviaData[currentQuestion].incorrect_answers
        shuffledAnswers.append(triviaData[currentQuestion].correct_answer)
        shuffledAnswers.shuffle()
    }
}

struct TriviaGame_Previews: PreviewProvider {
    static var previews: some View {
        TriviaGame()
    }
}
