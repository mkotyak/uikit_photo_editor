import UIKit

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        view.backgroundColor = .white

        setupNavigationBar()
        setupPlusImageView()
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
        debugPrint("didTapSaveButton")
    }

    private func setupPlusImageView() {
        view.addSubview(plusImageView)

        NSLayoutConstraint.activate([
            plusImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plusImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            plusImageView.widthAnchor.constraint(equalToConstant: 80),
            plusImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    private lazy var plusImageView: UIImageView = {
        let plusImageView = UIImageView(image: UIImage(systemName: "plus"))
        plusImageView.translatesAutoresizingMaskIntoConstraints = false
        plusImageView.contentMode = .scaleAspectFit
        plusImageView.isUserInteractionEnabled = true

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(plusImageTapped))
        plusImageView.addGestureRecognizer(tapGestureRecognizer)

        return plusImageView
    }()

    @objc private func plusImageTapped() {
        debugPrint("plusImageTapped")
    }
}
