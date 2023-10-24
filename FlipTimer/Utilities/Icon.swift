import Foundation

// Source: https://developer.apple.com/documentation/xcode/configuring_your_app_to_use_alternate_app_icons
enum Icon: String, CaseIterable, Identifiable {
    case primary = "AppIcon"
    case classicDark = "AppIconClassicDark"
    case classicLight = "AppIconClassicLight"

    var id: String {
        self.rawValue
    }

    var displayName: String {
        switch self {
        case .primary:
            "Primary"
        case .classicDark:
            "Classic dark"
        case .classicLight:
            "Classic light"
        }
    }

    var imageName: String {
        switch self {
        case .primary:
            "AppIconImage"
        case .classicDark:
            "AppIconClassicDarkImage"
        case .classicLight:
            "AppIconClassicLightImage"
        }
    }
}
