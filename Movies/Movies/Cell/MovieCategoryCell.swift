import UIKit
import SnapKit

final class MovieCategoryCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: MovieCategoryCell.self)

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubViews()
        setupConstraints()
        contentView.backgroundColor = .clear
        updateAppearance()
    }
    
    private func addSubViews() {
        contentView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    private func updateAppearance() {
        if isSelected {
            titleLabel.textColor = .white
        } else {
            titleLabel.textColor = .gray
        }
    }
}
