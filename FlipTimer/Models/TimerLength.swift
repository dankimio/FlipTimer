enum TimerLength: Int, CaseIterable {
    case min15 = 15
    case min25 = 25
    case min30 = 30
    case min45 = 45

    var inSeconds: Int {
        #if DEBUG
            return rawValue
        #else
            return rawValue * 60
        #endif
    }

    var name: String {
        return "\(rawValue) minutes"
    }
}
