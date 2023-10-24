import AVFoundation

class SoundManager: NSObject, AVAudioPlayerDelegate {
    static let shared = SoundManager()

    private var audioPlayer: AVAudioPlayer?

    func playStartSound() {
        // BeginRecording sound
        AudioServicesPlayAlertSound(SystemSoundID(1117))
    }

    func playPauseSound() {
        // EndRecording sound
        AudioServicesPlayAlertSound(SystemSoundID(1118))
    }

    func playSuccessSound() {
        try! AVAudioSession.sharedInstance().setCategory(.ambient, options: .duckOthers)
        try! AVAudioSession.sharedInstance().setActive(true)

        let url = Bundle.main.url(forResource: "success", withExtension: "m4a")!

        audioPlayer = try! AVAudioPlayer(contentsOf: url)
        audioPlayer?.play()
        audioPlayer?.delegate = self

        // Source: https://stackoverflow.com/a/33693071/2505156
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        try? AVAudioSession.sharedInstance().setActive(false)
    }
}
