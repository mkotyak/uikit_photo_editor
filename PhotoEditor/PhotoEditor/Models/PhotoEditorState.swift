import UIKit

struct PhotoEditorState {
    var selectedImage: UIImage?
    var filteredImage: UIImage?
    let filters: [FilterType] = FilterType.allCases
    var appliedFilter: FilterType = .original
}
