import Foundation

enum FilterType: String, CaseIterable {
    case original = "ORIGINAL"
    case mono = "MONO"

    var name: String? {
        switch self {
        case .original:
            return nil
        case .mono:
            return "CIPhotoEffectMono"
        }
    }
}
