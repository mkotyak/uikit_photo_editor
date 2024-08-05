import Foundation

enum FilterType: String, CaseIterable {
    case mono

    var name: String {
        switch self {
        case .mono:
            "CIPhotoEffectMono"
        }
    }
}
