import SwiftUI
import AVFoundation

enum TimerMode {
    case initial
    case running
    case paused
}

class TimerManager: ObservableObject {
    @Published var timerMode: TimerMode = .initial

    private let timerLength = 25 * 60

    private var startedAt: Date?
    @Published private var secondsElapsed = 0

    var timeLeft: String {
        let timeDifferenceInSeconds = timerLength - secondsElapsed

        let minutesLeft = timeDifferenceInSeconds / 60
        let secondsLeft = timeDifferenceInSeconds % 60

        let formattedMinutes = String(format: "%02d", minutesLeft)
        let formattedSeconds = String(format: "%02d", secondsLeft)

        return "\(formattedMinutes):\(formattedSeconds)"
    }

    func stop() {
        withAnimation {
            timerMode = .initial
        }
        startedAt = nil
        secondsElapsed = 0
    }

    // Source: https://gist.github.com/skl/a093291abc0a90a640e50f78888456e7
    @objc func proximityDidChange(notification: NSNotification) {
        print("proximityDidChange")

        guard let device = notification.object as? UIDevice else { return }

        device.proximityState ? proximitySensorDidClose() : proximitySensorDidUnclose()
    }

    private func proximitySensorDidClose() {
        // BeginRecording sound
        AudioServicesPlayAlertSound(SystemSoundID(1117))

        startedAt = Date()
        withAnimation {
            timerMode = .running
        }
    }

    private func proximitySensorDidUnclose() {
        // EndRecording sound
        AudioServicesPlayAlertSound(SystemSoundID(1118))

        let timeIntervalSinceStartedAt = Date().timeIntervalSince(startedAt!)
        let timeDifferenceInSeconds = Int(timeIntervalSinceStartedAt)
        secondsElapsed += timeDifferenceInSeconds
        withAnimation {
            timerMode = .paused
        }

        print(secondsElapsed)
    }
}
