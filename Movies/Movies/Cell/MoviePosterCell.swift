import UIKit
import SnapKit

final class MoviePosterCell: UICollectionViewCell {

    static let reuseIdentifier = String( describing: MoviePosterCell.self )

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(posterImageView)

        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }

    func configure(with imagePath: String?) {
        if let posterPath = imagePath {
            posterImageView.loadImage(url: posterPath)
        }
    }
}
