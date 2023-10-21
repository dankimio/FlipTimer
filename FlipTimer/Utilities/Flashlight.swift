import AVFoundation

struct Flashlight {
    static let shared = Flashlight()

    private let device = AVCaptureDevice.default(for: .video)

    private init() {}

    var hasFlashlight: Bool {
        return device?.hasTorch ?? false
    }

    func flash() {
        guard let device = device else { return }
        guard hasFlashlight, device.isTorchAvailable else { return }

        do {
            try device.lockForConfiguration()
            try device.setTorchModeOn(level: 0.1)

            device.unlockForConfiguration()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 ) {
                self.turnOffTorch()
            }
        } catch {
            print("Failed to lock for configuration")
        }
    }

    private func turnOffTorch() {
        guard let device = device else { return }
        
        do {
            try device.lockForConfiguration()
            device.torchMode = .off
            device.unlockForConfiguration()
        } catch {
            print("Failed to lock for configuration")
        }
    }
}
