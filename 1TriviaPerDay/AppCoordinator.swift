import Foundation
import Combine
import AppKit


class AppCoordinator: ObservableObject {
    private var cancellables = Set<AnyCancellable>()

    let notificationManager = NotificationManager()
    let networkManager = NetworkManager()

    func setup() {
        print("🔧 Coordinator setup started")
        notificationManager.requestPermission()
        fetchTriviaAndNotify()
    }

    private func fetchTriviaAndNotify() {
        print("🌐 Fetching trivia...")
        networkManager.fetchTrivia()

        networkManager.$triviaQuestion
            .sink { [weak self] trivia in
                guard let self = self, let trivia = trivia else {
                    print("⚠️ No trivia fetched")
                    return
                }
                print("📨 Sending notification for: \(trivia.question)")
                DispatchQueue.main.async {
                    self.notificationManager.sendTriviaNotification(trivia: trivia)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        NSApp.terminate(nil)
                    }
                }
            }
            .store(in: &cancellables)
    }

    
}
