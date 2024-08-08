import Combine
import Foundation

final class SettingsModuleViewModel {
    var settingsItems: CurrentValueSubject<[CellItem], Never> = .init([.init(title: "About Us")])

    // MARK: - Intents

    func viewDidAddNewItem(with title: String) {
        settingsItems.value.append(
            .init(title: title)
        )
    }
}
