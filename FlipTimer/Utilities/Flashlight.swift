import AVFoundation

struct Flashlight {
    static let shared = Flashlight()

    private let device = AVCaptureDevice.default(for: .video)

    private init() {}

    var hasFlashlight: Bool {
        return device?.hasTorch ?? false
    }
}
