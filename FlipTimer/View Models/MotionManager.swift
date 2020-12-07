import CoreMotion

final class MotionManager: ObservableObject {
    private var motionManager = CMMotionManager()

    @Published var isDeviceUpsideDown: Bool?

    private var x = 0.0
    private var y = 0.0
    private var z = 0.0

    init() {
        startMotionManager()
    }

    private func startMotionManager() {
        guard motionManager.isAccelerometerAvailable else { return }

        motionManager.accelerometerUpdateInterval = 1.0 / 20.0
        motionManager.startAccelerometerUpdates(to: .main) { (accelerometerData, error) in
            guard error == nil else { return }
            guard let data = accelerometerData else { return }

            self.x = data.acceleration.x
            self.y = data.acceleration.y
            self.z = data.acceleration.z
        }
    }

    private func updateDeviceStatus() {
        if self.z > 0.9 && self.z < 1.1 {
            isDeviceUpsideDown = true
        } else {
            isDeviceUpsideDown = false
        }
    }
}
