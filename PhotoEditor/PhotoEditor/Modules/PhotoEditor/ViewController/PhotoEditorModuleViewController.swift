import Combine
import UIKit

class PhotoEditorModuleViewController: UIViewController {
    let viewModel: PhotoEditorModuleViewModel = .init()
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

    func setupSaveButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "externaldrive"),
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped)
        )
    }

    @objc private func saveButtonTapped() {
        debugPrint("saveButtonTapped")
    }

    private func setupBinding() {
        viewModel.state
            .sink { [weak self] newState in
                guard let self else {
                    return
                }

                updateImageView(with: newState.filteredImage)
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

    private func setupFilters() {
        view.addSubview(filters)
        filters.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filters.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            filters.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            filters.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
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
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        addGestureRecognizers(to: imageView)

        setupFilters()
        setupSaveButton()

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

    private lazy var filters: UISegmentedControl = {
        let segmentedControl: UISegmentedControl = .init(items: viewModel.filters.map { $0.rawValue })
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(
            self,
            action: #selector(filterChanged(_:)),
            for: .valueChanged
        )

        return segmentedControl
    }()

    @objc private func filterChanged(_ sender: UISegmentedControl) {
        let selectedFilter = viewModel.filters[sender.selectedSegmentIndex]
        viewModel.viewDidSelectFilter(selectedFilter)
    }
}
