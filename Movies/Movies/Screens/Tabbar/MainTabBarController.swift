import UIKit
import SnapKit

final class MainTabBarController: UITabBarController {

    private let customTabBar = CustomTabBarView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupCustomTabBar()
        tabBar.isHidden = true
        selectTab(index: 0)
    }

    private func setupTabs() {
        let homeNav = UINavigationController(rootViewController: HomeViewController())
        let searchNav = UINavigationController(rootViewController: SearchViewController())
        let watchNav = UINavigationController(rootViewController: WatchListViewController())

        viewControllers = [homeNav, searchNav, watchNav]
    }

    private func setupCustomTabBar() {
        view.addSubview(customTabBar)

        customTabBar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(86)
        }

        customTabBar.onSelect = { [weak self] index in
            self?.selectTab(index: index)
        }
    }

    func selectTab(index: Int) {
        selectedIndex = index
        customTabBar.setSelected(index: index)
    }
}
