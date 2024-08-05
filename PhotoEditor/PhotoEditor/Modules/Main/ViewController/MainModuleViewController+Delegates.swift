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

        resetImageView() // this is required to reset previously applied gesture changes
        resetSegmentedControl()
        setupImageView()
        viewModel.viewDidSelectImage(selectedImage)

        dismiss(animated: true)
    }

    private func resetImageView() {
        imageView.removeFromSuperview()
        imageView = .init()
    }

    private func resetSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
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
