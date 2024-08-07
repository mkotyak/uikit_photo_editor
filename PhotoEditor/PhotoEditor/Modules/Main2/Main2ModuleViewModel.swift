import Combine
import UIKit

final class Main2ModuleViewModel {
    var selectedImage: CurrentValueSubject<UIImage?, Never> = .init(nil)

    // MARK: - Intents

    func viewDidSelectImage(_ newImage: UIImage) {
        selectedImage.value = newImage
    }
}
