import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabs()
    }

    private func configureTabs() {
        let mainViewController: MainViewController = .init()
        mainViewController.tabBarItem.image = .init(systemName: "scribble.variable")
        mainViewController.tabBarItem.title = "Main"

        let settingsViewController: SettingsViewController = .init()
        settingsViewController.tabBarItem.image = .init(systemName: "gearshape")
        settingsViewController.tabBarItem.title = "Settings"

        let mainNavigationViewController: UINavigationController = .init(rootViewController: mainViewController)
        let settingNavigationViewController: UINavigationController = .init(rootViewController: settingsViewController)

        tabBar.tintColor = .label
        tabBar.backgroundColor = .white

        setViewControllers(
            [mainNavigationViewController, settingNavigationViewController],
            animated: true
        )
    }
}
