import SwiftUI
import CoreMotion
import AVFoundation
import Combine

final class TimerViewModel: ObservableObject {
    @AppStorage("timerLength") var timerLength: TimerLength = .min25
    @Published var timerMode: TimerMode = .initial
    @Published var shouldOpenTimerLengthPicker = false
    @Published var shouldPresentSettingsView = false

    // Timer
    @AppStorage("strictMode") private var strictMode: Bool = false
    @AppStorage("flash") private var flashIsEnabled: Bool = false
    @Published private var secondsElapsed = 0
    @Published private var deviceIsFlipped = false
    private var startedAt: Date?
    private var proximityMonitoringAvailable = false

    // Accelerometer (iPad)
    private var motionManager = CMMotionManager()
    private var userBrightness: CGFloat?

    // Combine
    private var cancellable = Set<AnyCancellable>()

    // Audio
    private var audioPlayer: AVAudioPlayer?
    private let audioPlayerDelegate = AudioPlayerDelegate()

    init() {
        $timerMode
            .sink { (timerMode) in
                if timerMode != .initial {
                    self.shouldOpenTimerLengthPicker = false
                }
            }.store(in: &cancellable)

        $shouldPresentSettingsView
            .dropFirst()
            .removeDuplicates()
            .sink { (shouldOpenSettingsView) in
                shouldOpenSettingsView ? self.stopMonitoring() : self.startMonitoring()
            }
            .store(in: &cancellable)

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

    private var secondsUntilTimerEnds: Int {
        return timerLength.inSeconds - secondsElapsed
    }

    func startMonitoring() {
        UIDevice.current.isProximityMonitoringEnabled = true

        guard UIDevice.current.isProximityMonitoringEnabled else {
            print("Proximity monitoring unavailable")
            startMotionManager()
            return
        }

        proximityMonitoringAvailable = true

        print("Enabled proximity monitoring")
    }

    func stopMonitoring() {
        print("Disabled proximity monitoring")

        UIDevice.current.isProximityMonitoringEnabled = false

        motionManager.stopAccelerometerUpdates()
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

        brightenScreen()

        guard secondsUntilTimerEnds > 0 else {
            stop()
            return
        }

        if strictMode {
            stop()
            return
        }

        withAnimation {
            timerMode = .paused
        }

        // EndRecording sound
        AudioServicesPlayAlertSound(SystemSoundID(1118))

        print("secondsElapsed: \(secondsElapsed)")
    }

    private func tryToFinish() {
        let currentSecondsSinceStartedAt = secondsElapsed + secondsSinceStartedAt
        let currentSecondsUntilTimerEnds = timerLength.inSeconds - currentSecondsSinceStartedAt

        print("currentSecondsUntilTimerEnds: \(currentSecondsUntilTimerEnds)")
        guard timerMode == .running && currentSecondsUntilTimerEnds <= 0 else {
            return
        }

        // Play the sound when the timer ends
        // AudioServicesPlayAlertSound(SystemSoundID(1025))
        playSuccessSound()

        if flashIsEnabled {
            Flashlight.shared.flash()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                Flashlight.shared.flash()
            }
        }
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

            if self.isUpsideDown(accelerometerData: data) {
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

    private func isUpsideDown(accelerometerData: CMAccelerometerData) -> Bool {
        let z = accelerometerData.acceleration.z
        return z > 0.9 && z < 1.1
    }

    // TODO: extract
    private func playSuccessSound() {
        try! AVAudioSession.sharedInstance().setCategory(.ambient, options: .duckOthers)
        try! AVAudioSession.sharedInstance().setActive(true)

        let url = Bundle.main.url(forResource: "success", withExtension: "m4a")!

        audioPlayer = try! AVAudioPlayer(contentsOf: url)
        audioPlayer?.play()
        audioPlayer?.delegate = audioPlayerDelegate
    }
}

// TODO: extract
class AudioPlayerDelegate: NSObject, AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        try? AVAudioSession.sharedInstance().setActive(false)
    }
}
