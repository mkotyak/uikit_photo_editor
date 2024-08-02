import Combine
import UIKit

class MainModuleViewController: UIViewController {
    let viewModel: MainModuleViewModel = .init()
    var cancellables: Set<AnyCancellable> = .init()

    var imageView: UIImageView = .init()
    var plusButton: UIButton = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        subscribeOnSelectedImageUpdate()
        updateUI()
    }

    private func subscribeOnSelectedImageUpdate() {
        viewModel.selectedImage.sink { [weak self] newImage in
            guard let self else {
                return
            }

            imageView.removeFromSuperview()
            imageView = .init()
            imageView.image = newImage

            updateUI()
        }
        .store(in: &cancellables)
    }

    private func updateUI() {
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil

        imageView.removeFromSuperview()
        plusButton.removeFromSuperview()

        if imageView.image == nil {
            setupPlusButton()
        } else {
            setupNavigationBar()
            setupImageView()
        }
    }

    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(plusButtonTapped)
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: .init(named: "externaldrive"),
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped)
        )
    }

    @objc private func saveButtonTapped() {
        viewModel.viewDidSelectSave()
    }

    private func setupPlusButton() {
        plusButton = UIButton(type: .system)
        plusButton.setImage(
            UIImage(systemName: "plus"),
            for: .normal
        )

        plusButton.imageView?.contentMode = .scaleAspectFit

        view.addSubview(plusButton)

        plusButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            plusButton.widthAnchor.constraint(equalToConstant: 80),
            plusButton.heightAnchor.constraint(equalToConstant: 80),
            plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plusButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        if let imageView = plusButton.imageView {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 80),
                imageView.heightAnchor.constraint(equalToConstant: 80),
                imageView.centerXAnchor.constraint(equalTo: plusButton.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor)
            ])
        }

        plusButton.addTarget(
            self,
            action: #selector(plusButtonTapped),
            for: .touchUpInside
        )
    }

    @objc private func plusButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary

        present(imagePickerController, animated: true)
    }

    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(imageView)

        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])

        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))

        pinchGesture.delegate = self
        rotationGesture.delegate = self
        panGesture.delegate = self

        imageView.addGestureRecognizer(pinchGesture)
        imageView.addGestureRecognizer(rotationGesture)
        imageView.addGestureRecognizer(panGesture)
    }
}
