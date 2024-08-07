import Combine
import UIKit

final class Main2ModuleViewModel {
    private var originalSelectedImage: UIImage?

    var selectedImage: CurrentValueSubject<UIImage?, Never> = .init(nil)
    let filters: [String]

    init() {
        self.filters = ["original"] + FilterType.allCases.map { $0.rawValue }
    }

    private func revertToOrigin() {
        selectedImage.value = originalSelectedImage
    }

    private func apply(_ filter: FilterType) {
        guard let image = selectedImage.value else {
            return
        }

        selectedImage.value = image.addFilter(filter)
    }

    // MARK: - Intents

    func viewDidSelectImage(_ newImage: UIImage) {
        selectedImage.value = newImage
        originalSelectedImage = newImage
    }

    func viewDidSelectSave() {
        debugPrint("viewDidSelectSave")
    }

    func viewDidSelectFilter(at index: Int) {
        let filterName = filters[index]

        if filterName == "original" {
            revertToOrigin()
        } else if let filter = FilterType(rawValue: filterName) {
            apply(filter)
        }
    }
}
