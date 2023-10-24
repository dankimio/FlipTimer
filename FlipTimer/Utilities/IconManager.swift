import Foundation
import UIKit

class IconManager {
    @Published var icon = "AppIcon"

    /// Change the app icon
    func setAlternateAppIcon(icon: String) {
        // Avoid setting the name if the app already uses that icon.
        guard UIApplication.shared.alternateIconName != icon else { return }

        UIApplication.shared.setAlternateIconName(icon) { (error) in
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

        icon = alternateIconName
    }
}
