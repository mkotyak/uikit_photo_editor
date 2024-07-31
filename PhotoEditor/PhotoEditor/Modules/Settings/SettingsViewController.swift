import Combine
import UIKit

class SettingsViewController: UIViewController {
    private enum Constants {
        static var cellIdentifier: String { "cell" }
    }

    private let viewModel: SettingsViewModel = .init()
    private var cancellables: Set<AnyCancellable> = .init()

    private let tableView: UITableView = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        configureHeaderView()
        configureTableView()

        viewModel.settingsItems.sink { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &cancellables)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    @objc private func didTapAddButton() {
        viewModel.viewDidSelectAddNewItem(with: "New Item")
    }

    private func configureHeaderView() {
        title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddButton)
        )
    }

    private func configureTableView() {
        view.addSubview(tableView)
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: Constants.cellIdentifier
        )
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        present(
            SettingsDetailViewController(text: viewModel.settingsItems.value[indexPath.row].description),
            animated: true
        )
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.settingsItems.value.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(
            withIdentifier: Constants.cellIdentifier,
            for: indexPath
        )
        cell.textLabel?.text = viewModel.settingsItems.value[indexPath.row].title

        return cell
    }
}
