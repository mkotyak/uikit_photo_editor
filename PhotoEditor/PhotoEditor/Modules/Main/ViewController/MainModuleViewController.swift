import Combine
import UIKit

class MainModuleViewController: UIViewController {
    let viewModel: MainModuleViewModel = .init()
    var cancellables: Set<AnyCancellable> = .init()

    var imageView: UIImageView = .init()
    var imageOverlayView: UIView = .init()
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

        view.addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        addGestureRecognizers(to: imageView)
        setupImageOverlayView()
    }

    private func addGestureRecognizers(to: UIView) {
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

    private func setupImageOverlayView() {
        imageOverlayView = UIView()
        imageOverlayView.backgroundColor = .clear
        imageOverlayView.isUserInteractionEnabled = false
        view.addSubview(imageOverlayView)

        imageOverlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageOverlayView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageOverlayView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        let overlayColor: UIColor = .white.withAlphaComponent(0.7)

        let transparentRectangle = UIView()
        transparentRectangle.backgroundColor = .clear
        transparentRectangle.layer.borderColor = UIColor.yellow.cgColor
        transparentRectangle.layer.borderWidth = 2
        imageOverlayView.addSubview(transparentRectangle)

        let topOverlay = UIView()
        topOverlay.backgroundColor = overlayColor
        imageOverlayView.addSubview(topOverlay)

        let bottomOverlay = UIView()
        bottomOverlay.backgroundColor = overlayColor
        imageOverlayView.addSubview(bottomOverlay)

        let leftOverlay = UIView()
        leftOverlay.backgroundColor = overlayColor
        imageOverlayView.addSubview(leftOverlay)

        let rightOverlay = UIView()
        rightOverlay.backgroundColor = overlayColor
        imageOverlayView.addSubview(rightOverlay)

        let rectangleWidth: CGFloat = 250
        let rectangleHeight: CGFloat = 350

        topOverlay.translatesAutoresizingMaskIntoConstraints = false
        bottomOverlay.translatesAutoresizingMaskIntoConstraints = false
        leftOverlay.translatesAutoresizingMaskIntoConstraints = false
        rightOverlay.translatesAutoresizingMaskIntoConstraints = false
        transparentRectangle.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            transparentRectangle.centerXAnchor.constraint(equalTo: imageOverlayView.centerXAnchor),
            transparentRectangle.centerYAnchor.constraint(equalTo: imageOverlayView.centerYAnchor),
            transparentRectangle.widthAnchor.constraint(equalToConstant: rectangleWidth),
            transparentRectangle.heightAnchor.constraint(equalToConstant: rectangleHeight),

            topOverlay.leadingAnchor.constraint(equalTo: imageOverlayView.leadingAnchor),
            topOverlay.trailingAnchor.constraint(equalTo: imageOverlayView.trailingAnchor),
            topOverlay.topAnchor.constraint(equalTo: imageOverlayView.topAnchor),
            topOverlay.bottomAnchor.constraint(equalTo: transparentRectangle.topAnchor),

            bottomOverlay.leadingAnchor.constraint(equalTo: imageOverlayView.leadingAnchor),
            bottomOverlay.trailingAnchor.constraint(equalTo: imageOverlayView.trailingAnchor),
            bottomOverlay.topAnchor.constraint(equalTo: transparentRectangle.bottomAnchor),
            bottomOverlay.bottomAnchor.constraint(equalTo: imageOverlayView.bottomAnchor),

            leftOverlay.leadingAnchor.constraint(equalTo: imageOverlayView.leadingAnchor),
            leftOverlay.trailingAnchor.constraint(equalTo: transparentRectangle.leadingAnchor),
            leftOverlay.topAnchor.constraint(equalTo: transparentRectangle.topAnchor),
            leftOverlay.bottomAnchor.constraint(equalTo: transparentRectangle.bottomAnchor),

            rightOverlay.leadingAnchor.constraint(equalTo: transparentRectangle.trailingAnchor),
            rightOverlay.trailingAnchor.constraint(equalTo: imageOverlayView.trailingAnchor),
            rightOverlay.topAnchor.constraint(equalTo: transparentRectangle.topAnchor),
            rightOverlay.bottomAnchor.constraint(equalTo: transparentRectangle.bottomAnchor)
        ])
    }
}
