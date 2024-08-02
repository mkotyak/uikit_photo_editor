import UIKit

// MARK: - UITableViewDelegate

extension SettingsModuleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        present(
            SettingItemDetailsModuleViewController(description: viewModel.settingsItems.value[indexPath.row].description),
            animated: true
        )
    }
}

// MARK: - UITableViewDataSource

extension SettingsModuleViewController: UITableViewDataSource {
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
