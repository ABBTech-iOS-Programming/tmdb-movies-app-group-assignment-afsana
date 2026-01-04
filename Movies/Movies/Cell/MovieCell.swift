import UIKit
import SnapKit

final class MovieCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: MovieCell.self)
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .darkGray
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemOrange
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    private let starIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .systemOrange
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let genreIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "film")
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let calendarIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let languageIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "globe")
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        [
            posterImageView,
            titleLabel,
            starIcon,
            ratingLabel,
            genreIcon,
            genreLabel,
            calendarIcon,
            yearLabel,
            languageIcon,
            languageLabel
        ].forEach(contentView.addSubview)
        
        posterImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.bottom.lessThanOrEqualToSuperview().offset(-8)
            make.width.equalTo(95)
            make.height.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
            make.top.equalTo(posterImageView)
        }
        
        starIcon.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.width.height.equalTo(16)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.leading.equalTo(starIcon.snp.trailing).offset(4)
            make.centerY.equalTo(starIcon)
        }
        
        genreIcon.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(starIcon.snp.bottom).offset(8)
            make.width.height.equalTo(16)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.leading.equalTo(genreIcon.snp.trailing).offset(4)
            make.centerY.equalTo(genreIcon)
        }
        
        calendarIcon.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(genreIcon.snp.bottom).offset(8)
            make.width.height.equalTo(16)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.leading.equalTo(calendarIcon.snp.trailing).offset(4)
            make.centerY.equalTo(calendarIcon)
        }
        
        languageIcon.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(calendarIcon.snp.bottom).offset(8)
            make.width.height.equalTo(16)
        }
        
        languageLabel.snp.makeConstraints { make in
            make.leading.equalTo(languageIcon.snp.trailing).offset(4)
            make.centerY.equalTo(languageIcon)
            make.bottom.lessThanOrEqualToSuperview().offset(-8)
        }
    }
    
    func configure(with movie: MovieResult, genre: String) {
        titleLabel.text = movie.title
        ratingLabel.text = String(format: "%.1f", movie.voteAverage ?? 0)
        genreLabel.text = genre
        yearLabel.text = movie.releaseDate
        languageLabel.text = (movie.originalLanguage)
        
        if let posterURL = movie.posterPath {
            posterImageView.loadImage(url: posterURL)
        }
    }
}
