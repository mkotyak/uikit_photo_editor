import Combine
import Foundation
import UIKit

final class MainModuleViewModel {
    private var originalImage: UIImage?

    var selectedImage: CurrentValueSubject<UIImage?, Never> = .init(nil)
    let filters: [String]

    init() {
        self.filters = ["original"] + FilterType.allCases.map { $0.rawValue }
    }

    private func revertToOrigin() {
        selectedImage.value = originalImage
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
        originalImage = newImage
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
