import Foundation

enum Filter: String, CaseIterable {
    case original
    case mono

    var name: String? {
        switch self {
        case .original:
            return nil
        case .mono:
            return "CIPhotoEffectMono"
        }
    }
}
