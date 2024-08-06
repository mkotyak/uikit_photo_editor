import Combine
import UIKit

class MainModuleViewController: UIViewController {
    let viewModel: MainModuleViewModel = .init()
    var cancellables: Set<AnyCancellable> = .init()

    var segmentedControl: UISegmentedControl = .init()
    var plusButton: UIButton = .init(type: .system)
    var imageView: UIImageView = .init()
    var imageOverlayView: UIView = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupUI()
        setupBinding()
    }

    private func setupUI() {
        setupSegmentedControl()
        setupPlusButton()

        refreshUI()
    }

    private func refreshUI() {
        let hasImage = imageView.image != nil

        navigationItem.rightBarButtonItem = hasImage ? UIBarButtonItem(
            image: UIImage(named: "externaldrive"),
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped)
        ) : nil

        navigationItem.leftBarButtonItem = hasImage ? UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(plusButtonTapped)
        ) : nil

        plusButton.isHidden = hasImage
        segmentedControl.isHidden = !hasImage
        imageView.isHidden = !hasImage
        imageOverlayView.isHidden = !hasImage
    }

    private func setupBinding() {
        viewModel.selectedImage
            .sink { [weak self] newImage in
                guard let self else {
                    return
                }

                imageView.image = newImage
                refreshUI()
            }
            .store(in: &cancellables)
    }

    private func setupSegmentedControl() {
        segmentedControl = .init(items: viewModel.filters)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(
            self,
            action: #selector(segmentedControlChanged(_:)),
            for: .valueChanged
        )

        view.addSubview(segmentedControl)

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 30)
        ])
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

    func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true

        view.insertSubview(imageView, at: 0)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 12),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        addGestureRecognizers(to: imageView)
        setupImageOverlayView()
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
            imageOverlayView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 12),
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

        setupHeadlineBackroundView()
    }

    private func setupHeadlineBackroundView() {
        let headlineBackroundView = UIView()
        headlineBackroundView.backgroundColor = .white
        view.insertSubview(headlineBackroundView, belowSubview: segmentedControl)

        headlineBackroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headlineBackroundView.topAnchor.constraint(equalTo: view.topAnchor),
            headlineBackroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headlineBackroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headlineBackroundView.bottomAnchor.constraint(equalTo: imageView.topAnchor)
        ])
    }

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

    // MARK: - @objc methods

    @objc private func saveButtonTapped() {
        viewModel.viewDidSelectSave()
    }

    @objc private func segmentedControlChanged(_ sender: UISegmentedControl) {
        viewModel.viewDidSelectFilter(at: sender.selectedSegmentIndex)
    }

    @objc private func plusButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary

        present(
            imagePickerController,
            animated: true
        )
    }
}
