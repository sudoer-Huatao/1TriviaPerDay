import SwiftUI
import UserNotifications

@main
struct TriviaApp: App {
    // ✅ Plain reference (NOT a StateObject)
    let coordinator = AppCoordinator()
    let notificationDelegate = NotificationDelegate() // Create an instance of the delegate

    init() {
        coordinator.setup()
        UNUserNotificationCenter.current().delegate = notificationDelegate // Set the delegate
    }

    var body: some Scene {
        // ✅ No visible UI
        Settings {
            EmptyView()
        }
    }
}
