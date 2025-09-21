import Foundation
import Combine

class NetworkManager: ObservableObject {
    @Published var triviaQuestion: TriviaQuestion?

    func fetchTrivia() {
        guard let url = URL(string: "https://opentdb.com/api.php?amount=1&type=multiple") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching trivia: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data returned")
                return
            }

            do {
                let decoded = try JSONDecoder().decode(TriviaResponse.self, from: data)
                DispatchQueue.main.async {
                    self.triviaQuestion = decoded.results.first
                }
            } catch {
                print("Error decoding trivia: \(error.localizedDescription)")
                if let raw = String(data: data, encoding: .utf8) {
                    print("Raw response: \(raw)")
                }
            }
        }.resume()
    }
}
