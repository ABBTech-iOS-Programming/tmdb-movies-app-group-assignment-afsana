import UIKit
import SnapKit

final class HomeViewController: UIViewController {

    private let searchView = CustomSearchView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .accent
        setupUI()
        bindSearchAction()
    }

    private func bindSearchAction() {
        searchView.onSearchTapped = { [weak self] in
            self?.switchToSearchTab()
        }
    }

    private func switchToSearchTab() {
        guard let tabBar = tabBarController as? MainTabBarController else { return }
        tabBar.selectTab(index: 1) 
    }

    private func setupUI() {
        view.addSubview(searchView)

        searchView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
}
