import SwiftUI

enum TimerMode {
    case initial
    case running
    case paused
}

class TimerManager: ObservableObject {
    var timerMode: TimerMode = .initial
}
