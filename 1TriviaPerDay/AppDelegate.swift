import SwiftUI

@main
struct TriviaApp: App {
    // ✅ Plain reference (NOT a StateObject)
    let coordinator = AppCoordinator()

    init() {
        coordinator.setup()
    }

    var body: some Scene {
        // ✅ No visible UI
        Settings {
            EmptyView()
        }
    }
}
