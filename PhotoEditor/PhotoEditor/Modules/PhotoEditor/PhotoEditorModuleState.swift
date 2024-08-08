import UIKit

struct PhotoEditorModuleState {
    var selectedImage: UIImage? {
        didSet {
            if selectedImage == nil {
                filteredImage = nil
            }
        }
    }

    var filteredImage: UIImage?
    let availableFilters: [Filter] = Filter.allCases
    var currentFilter: Filter = .original
}
