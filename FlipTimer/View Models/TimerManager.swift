import SwiftUI
import AVFoundation

enum TimerMode {
    case initial
    case running
    case paused
}

class TimerManager: ObservableObject {
    @Published var timerMode: TimerMode = .initial

    private let timerLength = 5 // 25 * 60

    private var startedAt: Date?
    @Published private var secondsElapsed = 0

    var timeLeft: String {
        let minutesLeft = secondsUntilTimerEnds / 60
        let secondsLeft = secondsUntilTimerEnds % 60

        guard minutesLeft >= 0 && secondsLeft >= 0 else { return "00:00" }

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

    private var secondsUntilTimerEnds: Int {
        return timerLength - secondsElapsed
    }

    private func proximitySensorDidClose() {
        // BeginRecording sound
        AudioServicesPlayAlertSound(SystemSoundID(1117))

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(secondsUntilTimerEnds)) {
            self.tryToFinish()
        }

        startedAt = Date()
        withAnimation {
            timerMode = .running
        }
    }

    private func proximitySensorDidUnclose() {
        let timeIntervalSinceStartedAt = Date().timeIntervalSince(startedAt!)
        let timeDifferenceInSeconds = Int(timeIntervalSinceStartedAt)
        secondsElapsed += timeDifferenceInSeconds

        guard secondsUntilTimerEnds > 0 else {
            withAnimation {
                timerMode = .initial
            }
            startedAt = nil
            secondsElapsed = 0

            return
        }

        withAnimation {
            timerMode = .paused
        }

        // EndRecording sound
        AudioServicesPlayAlertSound(SystemSoundID(1118))

        print(secondsElapsed)
    }

    private func tryToFinish() {
        guard timerMode == .running else {
            return
        }

        // Play the sound when the timer ends
        AudioServicesPlayAlertSound(SystemSoundID(1025))
    }
}
