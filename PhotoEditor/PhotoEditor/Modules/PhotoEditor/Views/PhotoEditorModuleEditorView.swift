import UIKit

class PhotoEditorModuleEditorView: UIView {
    let imageView: UIImageView = .init()

    init() {
        super.init(frame: .zero)

        setupView()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        layer.borderWidth = 4
        layer.borderColor = UIColor.yellow.cgColor
        clipsToBounds = true

        addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
    }

    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func addGestureRecognizers(
        pinchGesture: UIPinchGestureRecognizer,
        rotationGesture: UIRotationGestureRecognizer,
        panGesture: UIPanGestureRecognizer
    ) {
        imageView.addGestureRecognizer(pinchGesture)
        imageView.addGestureRecognizer(rotationGesture)
        imageView.addGestureRecognizer(panGesture)
    }
}
