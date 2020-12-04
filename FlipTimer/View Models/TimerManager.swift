import SwiftUI
import AVFoundation

enum TimerMode {
    case initial
    case running
    case paused
}

class TimerManager: ObservableObject {
    @Published var timerMode: TimerMode = .initial

    // Source: https://gist.github.com/skl/a093291abc0a90a640e50f78888456e7
    @objc func proximityDidChange(notification: NSNotification) {
        print("proximityDidChange")

        guard let device = notification.object as? UIDevice else { return }

        device.proximityState ? proximitySensorDidClose() : proximitySensorDidUnclose()
    }

    private func proximitySensorDidClose() {
        // BeginRecording
        AudioServicesPlayAlertSound(SystemSoundID(1117))

        timerMode = .running
    }

    private func proximitySensorDidUnclose() {
        // EndRecording
        AudioServicesPlayAlertSound(SystemSoundID(1118))

        timerMode = .paused
    }
}
