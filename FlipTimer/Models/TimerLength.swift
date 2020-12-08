enum TimerLength: Int, CaseIterable {
    case min15 = 15
    case min25 = 25
    case min30 = 30
    case min45 = 45

    var inSeconds: Int {
        rawValue * 60
    }

    var name: String {
        return "\(rawValue) minutes"
    }
}
