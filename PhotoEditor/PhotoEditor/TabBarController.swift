import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabs()
    }

    private func configureTabs() {
        let firstTab = MainViewController()
        firstTab.tabBarItem.image = .init(systemName: "scribble.variable")
        firstTab.tabBarItem.title = "Main"

        let secondTab = SettingsViewController()
        secondTab.tabBarItem.image = .init(systemName: "gearshape")
        secondTab.tabBarItem.title = "Settings"

        tabBar.tintColor = .label
        tabBar.backgroundColor = .white

        setViewControllers([firstTab, secondTab], animated: true)
    }
}
