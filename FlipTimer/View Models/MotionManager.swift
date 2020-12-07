import CoreMotion

final class MotionManager: ObservableObject {
    private var motionManager = CMMotionManager()

    private var x = 0.0
    private var y = 0.0
    private var z = 0.0

    init() {
        guard motionManager.isAccelerometerAvailable else {
            return
        }

        motionManager.accelerometerUpdateInterval = 1.0 / 20.0
        motionManager.startAccelerometerUpdates(to: .main) { (accelerometerData, error) in
            guard error == nil else { return }
            guard let data = accelerometerData else { return }

            self.x = data.acceleration.x
            self.y = data.acceleration.y
            self.z = data.acceleration.z
        }
    }
}
