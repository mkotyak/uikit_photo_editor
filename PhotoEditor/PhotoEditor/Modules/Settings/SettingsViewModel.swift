import Combine
import Foundation

final class SettingsViewModel {
    var settingsItems: CurrentValueSubject<[SettingsItem], Never> = .init([.init(title: "About Us")])

    // MARK: - Intents

    func viewDidSelectAddNewItem(with title: String) {
        settingsItems.value.append(
            .init(title: title)
        )
    }
}
