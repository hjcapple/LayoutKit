import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    fileprivate var _window: UIWindow!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let aController = TestTableViewController()
        let navigationController = UINavigationController(rootViewController: aController)
        navigationController.navigationBar.isTranslucent = false

        _window = UIWindow(frame: UIScreen.main.bounds)
        _window.rootViewController = navigationController
        _window.makeKeyAndVisible()
        
        return true
    }
}

