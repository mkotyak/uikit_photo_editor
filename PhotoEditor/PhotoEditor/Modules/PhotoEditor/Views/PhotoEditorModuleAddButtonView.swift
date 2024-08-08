import UIKit

class PhotoEditorModuleAddButtonView: UIButton {
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
        setImage(
            UIImage(systemName: "plus"),
            for: .normal
        )

        imageView?.contentMode = .scaleAspectFit
    }

    private func setupConstraints() {
        guard let imageView else {
            return
        }

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
