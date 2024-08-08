import Combine
import UIKit

final class PhotoEditorModuleViewModel {
    private(set) var state: CurrentValueSubject<PhotoEditorModuleState, Never> = .init(.init())

    var availableFilters: [Filter] {
        state.value.availableFilters
    }

    private func applyFilter() {
        guard let selectedImage = state.value.selectedImage else {
            return
        }

        state.value.filteredImage = selectedImage.withFilter(state.value.currentFilter)
    }

    // MARK: - Intents

    func viewDidSelectImage(_ newImage: UIImage) {
        state.value.selectedImage = newImage
        applyFilter()
    }

    func viewDidSelectFilter(_ newFilter: Filter) {
        state.value.currentFilter = newFilter
        applyFilter()
    }
}

extension Filter {
    var controlTitle: String {
        switch self {
        case .original:
            return "ORIGINAL"
        case .mono:
            return "MONO"
        }
    }
}
