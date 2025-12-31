import UIKit
import SnapKit

final class CustomSearchView: UIView {

    var onSearchTapped: (() -> Void)?

    var isEditable: Bool = false {
        didSet {
            textField.isUserInteractionEnabled = isEditable
            tapGesture?.isEnabled = !isEditable
        }
    }

    private let searchIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = .lightGray
        return imageView
    }()

    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [
                .foregroundColor: UIColor.lightGray
            ]
        )
        textField.tintColor = .systemBlue
        textField.backgroundColor = .clear
        textField.isUserInteractionEnabled = false
        return textField
    }()

    private var tapGesture: UITapGestureRecognizer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        addSubviews()
        setupConstraints()
        addTapGesture()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func configureView() {
        backgroundColor = .graphiteGray
        layer.cornerRadius = 16
    }

    private func addSubviews() {
        addSubview(searchIcon)
        addSubview(textField)
    }

    private func setupConstraints() {

        searchIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }

        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalTo(searchIcon.snp.trailing).inset(12)
            make.top.bottom.equalToSuperview()
        }
    }

    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(searchTapped))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
        tapGesture = tap
    }

    @objc private func searchTapped() {
        onSearchTapped?()
    }
}
