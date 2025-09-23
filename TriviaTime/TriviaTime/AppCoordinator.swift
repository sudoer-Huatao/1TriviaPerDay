import Foundation
import Combine
import AppKit

class AppCoordinator: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private var timer: AnyCancellable?

    let notificationManager = NotificationManager()
    let networkManager = NetworkManager()

    func setup() {
        print("🔧 Coordinator setup started")
        notificationManager.requestPermission()
        startThirtyMinuteNotifications()
    }

    private func startThirtyMinuteNotifications() {
        // Schedule the first notification immediately
        fetchTriviaAndNotify()

        // Create a timer that triggers every 30 minutes (1800 seconds)
        timer = Timer.publish(every: 1800, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.fetchTriviaAndNotify()
            }
    }

    private func fetchTriviaAndNotify() {
        print("🌐 Fetching trivia...")
        networkManager.fetchTrivia()

        networkManager.$triviaQuestion
            .dropFirst() // Ignore the first value since it's the initial nil
            .sink { [weak self] trivia in
                guard let self = self, let trivia = trivia else {
                    print("⚠️ No trivia fetched")
                    return
                }
                print("📨 Sending notification for: \(trivia.question)")
                DispatchQueue.main.async {
                    self.notificationManager.sendTriviaNotification(trivia: trivia)
                }
            }
            .store(in: &cancellables)
    }

    deinit {
        timer?.cancel() // Clean up the timer when the coordinator is deallocated
    }
}
