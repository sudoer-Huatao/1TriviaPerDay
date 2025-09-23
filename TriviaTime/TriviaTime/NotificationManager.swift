import Foundation
import UserNotifications

class NotificationManager {
    
    // Requesting notification permission
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
            if !granted {
                print("Permission denied!")
            } else {
                print("Permission granted!")
            }
        }
    }

    // Decoding HTML entities into readable characters
    func decodeHtmlEntities(_ text: String) -> String {
        guard let data = text.data(using: .utf8) else { return text }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            let decodedString = try NSAttributedString(data: data, options: options, documentAttributes: nil).string
            return decodedString
        } catch {
            print("Error decoding HTML entities: \(error)")
            return text // Return original text in case of error
        }
    }

    // Sending the trivia notification
    func sendTriviaNotification(trivia: TriviaQuestion) {
        let content = UNMutableNotificationContent()
        content.title = "Trivia Time!"

        // Decode the question and answers
        let decodedQuestion = decodeHtmlEntities(trivia.question)
        let decodedAnswers = trivia.allAnswers.shuffled().map {
            decodeHtmlEntities($0)
        }

        content.body = "\(decodedQuestion)\n\n" + decodedAnswers.map {
            $0 == trivia.correct_answer ? "⭐️ \($0)" : $0
        }.joined(separator: "\n")
        
        content.sound = .default

        // Schedule the notification with a slight delay
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        
        // Add a slight delay before adding the notification request
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled.")
                }
            }
        }
    }

}
