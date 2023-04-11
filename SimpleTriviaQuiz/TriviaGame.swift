import SwiftUI

struct TriviaGame: View {
    @State var trivias: [Trivia] = SampleTrivias // Stores all the trivia data
    @State var isComplete: Bool = false // Indicates whether a question has already been answered
    @State var current: Int = 0 // Current question we are answering
    @State var answers: [String] = [] // Stores the possible answers
    @State var score: Int = 0 // Number of user's correct answers
    @Environment(\.dismiss) var dismiss // Function that returns to the home screen
    
    var body: some View {
        VStack(spacing: 20) {
            if trivias.isEmpty { // No data :/
                Text("Loading...")
            } else {
                if current >= trivias.count {
                    ScoreView()
                        .font(.system(size: 24, weight: .regular))
                } else {
                    TriviaView()
                        .onAppear {
                            answers = trivias[current].getAnswers()
                        }
                }
            }
        } // VStack
        .padding([.leading, .trailing])
        .onAppear {
//            apiRequest()
        }
    } // body
    
    @ViewBuilder
    func ScoreView() -> some View {
        Text("You scored: \(score)/\(trivias.count)")
        Button(action: { reset() }) {
            Text("Retry")
        } // Button
        Button(action: { dismiss() }) {
            Text("Go back")
        } // Button
    }
    
    @ViewBuilder
    func TriviaView() -> some View {
        HStack {
            Text("\(trivias[current].question)")
                .font(.system(size: 28, weight: .medium))
            Spacer()
        } // HStack
        ForEach(answers, id: \.self) { answer in
            Button(action: {
                checkAnswer(selected: answer)
            }) {
                Text("\(answer)")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(Color.black)
                    .frame(maxWidth: .infinity, maxHeight: 65)
                    .background(isComplete
                                && trivias[current].correct_answer == answer
                                ? Color.green : Color.white)
                    .cornerRadius(12)
                    .overlay(alignment: .center) {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 1)
                    }
            } // Button
        } // ForEach
        if isComplete {
            Button(action: { next() }) {
                Text("Next")
                    .font(.system(size: 26, weight: .medium))
                    .foregroundColor(Color.white)
                    .frame(width: 180, height: 60)
                    .background(Color.blue)
                    .cornerRadius(12)
            } // Button
        }
        Spacer()
    }
    
    func checkAnswer(selected: String) {
        if isComplete { return } // Do not allow re-answering
        isComplete = true
        if selected == trivias[current].correct_answer {
            score += 1
        }
    }
    
    func reset() {
        isComplete = false
        current = 0
        score = 0
    }
    
    func next() {
        current += 1
        if current >= trivias.count { return }
        answers = trivias[current].getAnswers()
        isComplete = false
    }
    
    func apiRequest() {
        Task {
            trivias = await fetchTriviaData()
            if !trivias.isEmpty { answers = trivias[current].getAnswers() }
        }
    }
}

struct TriviaGame_Previews: PreviewProvider {
    static var previews: some View {
        TriviaGame()
    }
}
