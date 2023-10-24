import SwiftUI
import Combine

final class SettingsViewModel: ObservableObject {
    @AppStorage("strictMode") var strictMode: Bool = false
    @AppStorage("flash") var flash: Bool = false

    @Published var icon: Icon = .primary

    // Combine
    private var cancellable = Set<AnyCancellable>()

    init() {
        if let alternateIconName = UIApplication.shared.alternateIconName {
            icon = Icon(rawValue: alternateIconName)!
        }

        $icon
            .sink { (icon) in
                print(444)
            }
            .store(in: &cancellable)
    }

    /// Change the app icon
    private func setAlternateAppIcon(icon: Icon) {
        // Set the icon name to nil to use the primary icon.
        let iconName: String? = (icon != .primary) ? icon.rawValue : nil

        // Avoid setting the name if the app already uses that icon.
        guard UIApplication.shared.alternateIconName != iconName else { return }

        UIApplication.shared.setAlternateIconName(iconName) { (error) in
            if let error = error {
                print("Failed request to update the app’s icon: \(error)")
            }
        }

        self.icon = icon
    }
}
