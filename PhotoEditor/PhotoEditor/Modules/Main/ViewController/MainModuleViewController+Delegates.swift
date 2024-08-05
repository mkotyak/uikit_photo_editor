import UIKit

// MARK: - UINavigationControllerDelegate

extension MainModuleViewController: UINavigationControllerDelegate {}

// MARK: - UIImagePickerControllerDelegate

extension MainModuleViewController: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }

        resetImageView() // reset is required to reset applie
        setupImageView()
        viewModel.viewDidSelectImage(selectedImage)

        dismiss(animated: true)
    }

    private func resetImageView() {
        imageView.removeFromSuperview()
        imageView = .init()
    }
}

// MARK: - UIGestureRecognizerDelegate

extension MainModuleViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}
