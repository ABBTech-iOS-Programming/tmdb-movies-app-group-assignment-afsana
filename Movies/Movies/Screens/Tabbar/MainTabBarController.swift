//
//  MainTabBarController.swift
//  Movies
//
//  Created by Afsana on 31.12.25.
//


import UIKit
import SnapKit

final class MainTabBarController: UITabBarController {

    private let customTabBar = CustomTabBarView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupCustomTabBar()
        tabBar.isHidden = true
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
            self?.selectedIndex = index
        }

        customTabBar.setSelected(index: 0)
    }
}
