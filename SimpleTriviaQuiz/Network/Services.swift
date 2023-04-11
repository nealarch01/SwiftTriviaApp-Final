import Foundation

extension Trivia {
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
    
    mutating func removePercentEncoding() {
        if results == nil { return }
        for i in 0..<results!.count {
            results![i].removePercentEncoding()
        }
    }
}

func fetchTriviaData() async -> [Trivia] {
    let triviaURL = "https://opentdb.com/api.php?amount=5&category=9&encode=url3986"
    var httpRequest = URLRequest(url: URL(string: triviaURL)!)
    httpRequest.httpMethod = "GET"
    do {
        let (responseData, _) = try await URLSession.shared.data(for: httpRequest) // Make the HTTP request
        var decodedData = try JSONDecoder().decode(APIResponse.self, from: responseData) // Decode the request
        decodedData.removePercentEncoding()
        return decodedData.results ?? [] // Return the results or an empty string
    } catch let error {
        print(error.localizedDescription)
        return []
    }
}
