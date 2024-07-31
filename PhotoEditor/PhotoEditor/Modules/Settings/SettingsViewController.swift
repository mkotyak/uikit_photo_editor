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

    private func configureHeaderView() {
        title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddButton)
        )
    }

    @objc private func didTapAddButton() {
        let alertController: UIAlertController = .init(
            title: "New Item",
            message: "Enter a name for the new item",
            preferredStyle: .alert
        )

        alertController.addTextField { textField in
            textField.placeholder = "Item name"
        }

        let cancelAction: UIAlertAction = .init(title: "Cancel", style: .cancel)
        let addAction: UIAlertAction = .init(title: "Add", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first,
                  let text = textField.text,
                  !text.isEmpty
            else {
                return
            }

            self?.viewModel.viewDidAddNewItem(with: text)
        }

        alertController.addAction(cancelAction)
        alertController.addAction(addAction)

        present(alertController, animated: true, completion: nil)
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
            SettingsItemDetailViewController(text: viewModel.settingsItems.value[indexPath.row].description),
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
