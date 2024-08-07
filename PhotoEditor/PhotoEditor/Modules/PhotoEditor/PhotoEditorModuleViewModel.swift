import Combine
import UIKit

final class PhotoEditorModuleViewModel {
    private var selectedImage: UIImage?
    private var appliedFilter: FilterType = .original

    var filteredImage: CurrentValueSubject<UIImage?, Never> = .init(nil)
    let filters: [FilterType] = FilterType.allCases

    private func applyFilter() {
        guard let selectedImage else {
            filteredImage.value = nil
            return
        }

        guard appliedFilter.name != nil else {
            filteredImage.value = selectedImage
            return
        }

        filteredImage.value = selectedImage.withFilter(appliedFilter)
    }

    // MARK: - Intents

    func viewDidSelectImage(_ newImage: UIImage) {
        selectedImage = newImage
        applyFilter()
    }

    func viewDidSelectFilter(_ filter: FilterType) {
        appliedFilter = filter
        applyFilter()
    }
}
