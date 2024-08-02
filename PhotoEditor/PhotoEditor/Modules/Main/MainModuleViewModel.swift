import Combine
import Foundation
import UIKit

final class MainModuleViewModel {
    var selectedImage: PassthroughSubject<UIImage, Never> = .init()

    // MARK: - Intents

    func viewDidSelectImage(_ newImage: UIImage) {
        selectedImage.send(newImage)
    }

    func viewDidSelectSave() {
        debugPrint("viewDidSelectSave")
    }
}
