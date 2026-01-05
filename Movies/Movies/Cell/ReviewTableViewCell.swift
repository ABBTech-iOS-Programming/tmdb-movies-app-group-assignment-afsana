//
//  ReviewTableViewCell.swift
//  Movies
//
//  Created by Afsana on 04.01.26.
//


import UIKit
import SnapKit

final class ReviewTableViewCell: UITableViewCell {

    static let reuseIdentifier = String(describing: ReviewTableViewCell.self)

    // MARK: - UI


    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .white
        imageView.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.8)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 22
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        return label
    }()

    private let reviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemBlue
        return label
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .accent
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(reviewLabel)
        contentView.addSubview(ratingLabel)

        avatarImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.size.equalTo(44)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
        }
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.leading.equalTo(nameLabel)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
        }
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(8)
            make.centerX.equalTo(avatarImageView)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
        }
    }

    // MARK: - Configure

    func configure(
        name: String,
        review: String,
        rating: Double,
        avatarURL: URL?
    ) {
        nameLabel.text = name
        reviewLabel.text = review
        ratingLabel.text = String(format: "%.1f", rating)

        if let url = avatarURL {
            avatarImageView.loadImage(url: url.absoluteString)
        } else {
            avatarImageView.image = UIImage(systemName: "person.fill")
        }
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = UIImage(systemName: "person.fill")
        nameLabel.text = nil
        reviewLabel.text = nil
        ratingLabel.text = nil
    }

}
