import UIKit

// MARK: - UINavigationControllerDelegate

extension Main2ModuleViewController: UINavigationControllerDelegate {}

// MARK: - UIImagePickerControllerDelegate

extension Main2ModuleViewController: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }

        viewModel.viewDidSelectImage(selectedImage)
        addButton.removeFromSuperview()
        setupPhotoEditorView()
        dismiss(animated: true)
    }

    private func resetImageView() {
//        imageView?.removeFromSuperview()
//        imageView = nil
    }

    private func resetSegmentedControl() {
//        segmentedControl.selectedSegmentIndex = 0
    }
}

// MARK: - UIGestureRecognizerDelegate

extension Main2ModuleViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}
