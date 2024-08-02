import Combine
import UIKit

class SettingsModuleViewController: UIViewController {
    enum Constants {
        static var cellIdentifier: String { "cell" }
    }

    let viewModel: SettingsModuleViewModel = .init()
    var cancellables: Set<AnyCancellable> = .init()

    let tableView: UITableView = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        subscribeOnsettingsItemsUpdate()

        setupHeaderView()
        setupTableView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    private func subscribeOnsettingsItemsUpdate() {
        viewModel.settingsItems.sink { [weak self] _ in
            self?.tableView.reloadData()
        }
        .store(in: &cancellables)
    }

    private func setupHeaderView() {
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

        present(alertController, animated: true)
    }

    private func setupTableView() {
        view.addSubview(tableView)

        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: Constants.cellIdentifier
        )

        tableView.delegate = self
        tableView.dataSource = self
    }
}
