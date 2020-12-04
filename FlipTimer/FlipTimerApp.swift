import SwiftUI

@main
struct FlipTimerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(timerMode: .initial)
        }
    }
}
