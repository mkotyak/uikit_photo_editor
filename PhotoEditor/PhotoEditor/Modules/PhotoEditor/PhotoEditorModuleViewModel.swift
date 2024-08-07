import Combine
import UIKit

final class PhotoEditorModuleViewModel {
    private(set) var state: CurrentValueSubject<PhotoEditorState, Never> = .init(.init())

    var filters: [FilterType] {
        state.value.filters
    }

    private func applyFilter() {
        guard let selectedImage = state.value.selectedImage else {
            state.value.filteredImage = nil
            return
        }

        guard let appliedFilterName = state.value.appliedFilter.name else {
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
}
