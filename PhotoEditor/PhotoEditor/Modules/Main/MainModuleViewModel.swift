import Combine
import Foundation
import UIKit

final class MainModuleViewModel {
    private var originalImage: UIImage = .init()

    var selectedImage: CurrentValueSubject<UIImage?, Never> = .init(nil)
    let filters: [String] = ["original"] + FilterType.allCases.map { $0.rawValue }

    private func revertToOrigin() {
        selectedImage.value = originalImage
    }

    private func apply(_ filter: FilterType) {
        selectedImage.value = selectedImage.value?.addFilter(filter)
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
        if filters[index] == "original" {
            revertToOrigin()
        } else {
            guard let filter = FilterType(rawValue: filters[index]) else {
                return
            }

            apply(filter)
        }
    }
}
