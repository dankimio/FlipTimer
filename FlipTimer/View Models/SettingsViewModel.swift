import SwiftUI

final class SettingsViewModel: ObservableObject {
    @AppStorage("strictMode") var strictMode: Bool = false
    @AppStorage("flash") var flash: Bool = false
}
