import UIKit

extension PhotoEditorModuleViewController {
    @objc func saveButtonTapped() {
        guard let image = photoEditorView.imageView.image else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(
            image,
            self,
            #selector(savingCompleted(_:didFinishSavingWithError:contextInfo:)),
            nil
        )
    }
    
    @objc func addButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        
        present(
            imagePickerController,
            animated: true
        )
    }
    
    @objc func filterChanged(_ sender: UISegmentedControl) {
        guard let selectedFilter = viewModel.availableFilters[safe: sender.selectedSegmentIndex] else {
            return
        }
        
        viewModel.viewDidSelectFilter(selectedFilter)
    }
    
    @objc func savingCompleted(
        _ image: UIImage,
        didFinishSavingWithError error: NSError?,
        contextInfo: UnsafeRawPointer
    ) {
        let title = error == nil ? "Saved!" : "Save error"
        let message = error?.localizedDescription ?? "Your image has been saved to your photos."
        
        showSavingResultAlert(title: title, message: message)
    }
    
    private func showSavingResultAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
}
