import Foundation
import UIKit

// Source: https://developer.apple.com/documentation/xcode/configuring_your_app_to_use_alternate_app_icons
enum Icon: String, CaseIterable, Identifiable {
    case primary = "AppIcon"
    case classicDark = "AppIconClassicDark"
    case classicLight = "AppIconClassicLight"

    var id: String {
        self.rawValue
    }
}

// Source: https://developer.apple.com/documentation/xcode/configuring_your_app_to_use_alternate_app_icons
class IconManager {
    @Published var icon: Icon = .primary

    /// Change the app icon
    func setAlternateAppIcon(icon: Icon) {
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

    private init() {
        guard let alternateIconName = UIApplication.shared.alternateIconName else {
            return
        }

        icon = Icon(rawValue: alternateIconName)!
    }
}
