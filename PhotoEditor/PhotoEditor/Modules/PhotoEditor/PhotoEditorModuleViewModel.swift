import Combine
import UIKit

final class PhotoEditorModuleViewModel {
    private let imageSaver: ImageSaverProtocol = ImageSaver()
    private(set) var state: CurrentValueSubject<PhotoEditorState, Never> = .init(.init())

    var filters: [FilterType] {
        state.value.filters
    }

    private func applyFilter() {
        guard state.value.selectedImage != nil else {
            state.value.filteredImage = nil
            return
        }

        guard state.value.appliedFilter.name != nil else {
            state.value.filteredImage = state.value.selectedImage
            return
        }

        state.value.filteredImage = state.value.selectedImage?.withFilter(state.value.appliedFilter)
    }

    private func updateSelectedImage(with newImage: UIImage) {
        state.value.selectedImage = newImage
    }

    private func updateAppliedFilter(with newFilter: FilterType) {
        state.value.appliedFilter = newFilter
    }

    // MARK: - Intents

    func viewDidSelectImage(_ newImage: UIImage) {
        updateSelectedImage(with: newImage)
        applyFilter()
    }

    func viewDidSelectFilter(_ filter: FilterType) {
        updateAppliedFilter(with: filter)
        applyFilter()
    }

    func viewDidSelectSave() {
        guard let image = state.value.filteredImage else {
            return
        }

        imageSaver.writeToPhotoAlbum(image: image)
    }
}
