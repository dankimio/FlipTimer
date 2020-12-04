import SwiftUI
import AVFoundation

enum TimerMode {
    case initial
    case running
    case paused
}

class TimerManager: ObservableObject {
    var timerMode: TimerMode = .initial

    // Source: https://gist.github.com/skl/a093291abc0a90a640e50f78888456e7
    @objc func proximityDidChange(notification: NSNotification) {
        print("ProximityObserver.didChange")

        guard let device = notification.object as? UIDevice else { return }

        // BeginRecording, EndRecording
        let systemSound = device.proximityState ? SystemSoundID(1117) : SystemSoundID(1118)
        AudioServicesPlayAlertSound(systemSound)
    }
}
