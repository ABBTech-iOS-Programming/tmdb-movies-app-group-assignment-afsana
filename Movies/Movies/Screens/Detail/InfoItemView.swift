import UIKit
import SnapKit

final class InfoItemView: UIStackView {

    private let iconView = UIImageView()
    private let label = UILabel()

    init(icon: String, text: String) {
        super.init(frame: .zero)

        axis = .horizontal
        spacing = 6
        alignment = .center

        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = .lightGray
        iconView.snp.makeConstraints { make in
            make.size.equalTo(16)
        }

        label.text = text
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14, weight: .regular)

        addArrangedSubview(iconView)
        addArrangedSubview(label)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(text: String) {
        label.text = text
    }
}
