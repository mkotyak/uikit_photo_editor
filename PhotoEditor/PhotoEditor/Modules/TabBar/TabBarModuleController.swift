import UIKit

class TabBarModuleController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabs()
    }

    private func configureTabs() {
        let mainViewController: Main2ModuleViewController = .init()
//        let mainViewController: MainModuleViewController = .init()
        mainViewController.tabBarItem.image = .init(systemName: "scribble.variable")
        mainViewController.tabBarItem.title = "Main"

        let settingsViewController: SettingsModuleViewController = .init()
        settingsViewController.tabBarItem.image = .init(systemName: "gearshape")
        settingsViewController.tabBarItem.title = "Settings"

        let mainNavigationViewController: UINavigationController = .init(rootViewController: mainViewController)
        let settingNavigationViewController: UINavigationController = .init(rootViewController: settingsViewController)

        tabBar.tintColor = .black
        tabBar.backgroundColor = .white

        setViewControllers(
            [mainNavigationViewController, settingNavigationViewController],
            animated: true
        )
    }
}
