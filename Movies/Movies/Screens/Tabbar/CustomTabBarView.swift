import UIKit
import SnapKit

final class CustomTabBarView: UIView {

    var onSelect: ((Int) -> Void)?

    // MARK: - UI
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()

    private var items: [TabBarItemView] = []

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    private func setupUI() {
        backgroundColor = .accent
        layer.cornerRadius = 24
        
        setupConstraints()
        setupItems()
    }

    // MARK: - Constraints
    private func setupConstraints() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(44)
            make.centerY.equalToSuperview()
        }
    }

    // MARK: - Items
    private func setupItems() {
        let home = TabBarItemView(title: "Home", icon: "house")
        let search = TabBarItemView(title: "Search", icon: "magnifyingglass")
        let watch = TabBarItemView(title: "Watch list", icon: "bookmark")

        items = [home, search, watch]

        items.enumerated().forEach { index, item in
            item.onTap = { [weak self] in
                self?.select(index: index)
            }
            stackView.addArrangedSubview(item)
        }
    }

    // MARK: - Selection
    private func select(index: Int) {
        setSelected(index: index)
        onSelect?(index)
    }

    func setSelected(index: Int) {
        items.enumerated().forEach { i, item in
            item.setSelected(i == index)
        }
    }
}
