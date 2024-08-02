import UIKit

// MARK: - UIImagePickerControllerDelegate

extension MainModuleViewController: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }

        viewModel.viewDidSelectImage(selectedImage)
        dismiss(animated: true)
    }
}

// MARK: - UINavigationControllerDelegate

extension MainModuleViewController: UINavigationControllerDelegate {}
