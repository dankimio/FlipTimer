import SwiftUI
import CoreMotion
import AVFoundation
import Combine

final class TimerViewModel: ObservableObject {
    @Published var timerMode: TimerMode = .initial

    private let timerLength = 25 * 60

    private var startedAt: Date?
    @Published private var secondsElapsed = 0
    @Published private var deviceIsFlipped = false

    private var proximityMonitoringAvailable = false
    private var motionManager = CMMotionManager()
    private var userBrightness: CGFloat?

    var timeLeft: String {
        let minutesLeft = secondsUntilTimerEnds / 60
        let secondsLeft = secondsUntilTimerEnds % 60

        guard minutesLeft >= 0 && secondsLeft >= 0 else { return "00:00" }

        let formattedMinutes = String(format: "%02d", minutesLeft)
        let formattedSeconds = String(format: "%02d", secondsLeft)

        return "\(formattedMinutes):\(formattedSeconds)"
    }

    private var cancellable = Set<AnyCancellable>()

    init() {
        $deviceIsFlipped
            .dropFirst()
            .removeDuplicates()
            .sink { (value) in
                value ? self.start() : self.pause()
            }
            .store(in: &cancellable)

        NotificationCenter.default.publisher(for: UIDevice.proximityStateDidChangeNotification)
            .sink { (notification) in
                guard let device = notification.object as? UIDevice else { return }

                self.deviceIsFlipped = device.proximityState
            }
            .store(in: &cancellable)
    }

    func stop() {
        withAnimation {
            timerMode = .initial
        }
        startedAt = nil
        secondsElapsed = 0
    }

    private var secondsUntilTimerEnds: Int {
        return timerLength - secondsElapsed
    }

    func startMonitoring() {
        UIDevice.current.isProximityMonitoringEnabled = true

        guard UIDevice.current.isProximityMonitoringEnabled else {
            print("Proximity monitoring unavailable")
            startMotionManager()
            return
        }

        proximityMonitoringAvailable = true

        print("Activated proximity monitoring")
    }

    func stopMonitoring() {
        print("deactivateProximitySensor")

        UIDevice.current.isProximityMonitoringEnabled = false
    }

    private func start() {
        print("Device flipped")

        // BeginRecording sound
        AudioServicesPlayAlertSound(SystemSoundID(1117))

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(secondsUntilTimerEnds)) {
            self.tryToFinish()
        }

        startedAt = Date()
        withAnimation {
            timerMode = .running
        }

        dimScreen()
    }

    private func pause() {
        print("Device unflipped")

        secondsElapsed += secondsSinceStartedAt

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

        brightenScreen()

        print("secondsElapsed: \(secondsElapsed)")
    }

    private func tryToFinish() {
        let currentSecondsSinceStartedAt = secondsElapsed + secondsSinceStartedAt
        let currentSecondsUntilTimerEnds = timerLength - currentSecondsSinceStartedAt

        print("currentSecondsUntilTimerEnds: \(currentSecondsUntilTimerEnds)")
        guard timerMode == .running && currentSecondsUntilTimerEnds <= 0 else {
            return
        }

        // Play the sound when the timer ends
        AudioServicesPlayAlertSound(SystemSoundID(1025))
    }

    private var secondsSinceStartedAt: Int {
        guard let startedAt = startedAt else { return 0 }

        let timeIntervalSinceStartedAt = Date().timeIntervalSince(startedAt)
        return Int(timeIntervalSinceStartedAt)
    }

    private func dimScreen() {
        guard !proximityMonitoringAvailable else {
            return
        }

        userBrightness = UIScreen.main.brightness
        UIScreen.main.brightness = 0.0
    }

    private func brightenScreen() {
        guard !proximityMonitoringAvailable && userBrightness != nil else {
            return
        }

        UIScreen.main.brightness = self.userBrightness!
    }

    func startMotionManager() {
        guard motionManager.isAccelerometerAvailable else { return }

        motionManager.accelerometerUpdateInterval = 1.0 / 2.0
        motionManager.startAccelerometerUpdates(to: .main) { (accelerometerData, error) in
            guard error == nil else { return }
            guard let data = accelerometerData else { return }

            let z = data.acceleration.z

            if z > 0.9 && z < 1.1 {
                if !self.deviceIsFlipped {
                    self.deviceIsFlipped = true
                }
            } else {
                if self.deviceIsFlipped {
                    self.deviceIsFlipped = false
                }
            }
        }

        print("Started accelerometer monitoring")
    }
}
