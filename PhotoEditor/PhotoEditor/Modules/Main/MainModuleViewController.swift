import Combine
import UIKit

class MainModuleViewController: UIViewController, UINavigationControllerDelegate {
    private let viewModel: MainModuleViewModel = .init()
    private var cancellables: Set<AnyCancellable> = .init()

    private let imageView: UIImageView = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        viewModel.selectedImage.sink { [weak self] newImage in
            guard let self else {
                return
            }

            imageView.image = newImage
            updateUI()
        }
        .store(in: &cancellables)

        updateUI()
    }

    private func updateUI() {
        navigationItem.rightBarButtonItem = nil
        imageView.removeFromSuperview()

        if imageView.image == nil {
            setupPlusButton()
        } else {
            setupNavigationBar()
            setupImageView()
        }
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = saveBarButton
    }

    private lazy var saveBarButton: UIBarButtonItem = {
        let imageView: UIImageView = .init(image: .init(named: "externaldrive"))
        imageView.contentMode = .scaleAspectFit

        let label: UILabel = .init()
        label.text = "Save"
        label.font = UIFont.systemFont(ofSize: 16)

        let stackView: UIStackView = .init(arrangedSubviews: [imageView, label])
        stackView.axis = .horizontal
        stackView.spacing = 5

        let containerView: UIView = .init()
        containerView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSaveButton))
        containerView.addGestureRecognizer(tapGesture)

        return UIBarButtonItem(customView: containerView)
    }()

    @objc private func didTapSaveButton() {
        viewModel.viewDidSelectSave()
    }

    private func setupPlusButton() {
        let plusButton = UIButton(type: .system)
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
        imageView.addGestureRecognizer(pinchGesture)
    }

    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let view = gesture.view else {
            return
        }

        view.transform = view.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1
    }
}

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
