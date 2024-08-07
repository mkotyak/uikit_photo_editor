import Combine
import UIKit

class Main2ModuleViewController: UIViewController {
    let viewModel: Main2ModuleViewModel = .init()
    var cancellables: Set<AnyCancellable> = .init()
    let imageView: UIImageView = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupAddButton()
        setupBinding()
    }

    func setupPhotoEditorView() {
        view.addSubview(photoEditorView)
        photoEditorView.translatesAutoresizingMaskIntoConstraints = false
        photoEditorView.center = .init(x: view.center.x, y: view.center.y)
    }

    private func setupBinding() {
        viewModel.selectedImage
            .sink { [weak self] newImage in
                guard let self else {
                    return
                }

                updateImageView(with: newImage)
            }
            .store(in: &cancellables)
    }

    private func setupAddButton() {
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func updateImageView(with newImage: UIImage?) {
        imageView.image = newImage
    }

    // MARK: - UI Elements

    // addButton

    lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        button.setImage(
            UIImage(systemName: "plus"),
            for: .normal
        )
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(
            self,
            action: #selector(addButtonTapped),
            for: .touchUpInside
        )

        if let imageView = button.imageView {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 80),
                imageView.heightAnchor.constraint(equalToConstant: 80),
                imageView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
            ])
        }

        return button
    }()

    @objc private func addButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary

        present(
            imagePickerController,
            animated: true
        )
    }

    // photoEditorView

    private lazy var photoEditorView: UIView = {
        let photoEditorView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: 350,
            height: 350
        ))
        photoEditorView.layer.borderWidth = 4
        photoEditorView.layer.borderColor = UIColor.yellow.cgColor

        photoEditorView.addSubview(imageView)
        photoEditorView.clipsToBounds = true

        imageView.frame = photoEditorView.bounds
        imageView.isUserInteractionEnabled = true
        addGestureRecognizers(to: imageView)

        return photoEditorView
    }()

    private func addGestureRecognizers(to view: UIView) {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))

        pinchGesture.delegate = self
        rotationGesture.delegate = self
        panGesture.delegate = self

        view.addGestureRecognizer(pinchGesture)
        view.addGestureRecognizer(rotationGesture)
        view.addGestureRecognizer(panGesture)
    }
}
