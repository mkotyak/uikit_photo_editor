import UIKit

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        configureUI()
    }

    private func configureUI() {
        navigationItem.rightBarButtonItem = saveBarButton
    }

    private var saveBarButton: UIBarButtonItem {
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
    }

    @objc private func didTapSaveButton() {
        debugPrint("didTapSaveButton")
    }
}
