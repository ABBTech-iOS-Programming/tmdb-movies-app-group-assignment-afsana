import UIKit
import SnapKit

final class DetailViewController: UIViewController {
    // MARK: - UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.register(ReviewTableViewCell.self, forCellReuseIdentifier: ReviewTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var segmentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        collectionView.backgroundColor = .accent
        collectionView.showsHorizontalScrollIndicator = false
        collectionView
            .register(
                MovieCategoryCell.self,
                forCellWithReuseIdentifier: MovieCategoryCell.reuseIdentifier
            )
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

      private let posterImageView: UIImageView = {
          let imageView = UIImageView()
          imageView.contentMode = .scaleAspectFill
          imageView.clipsToBounds = true
          imageView.layer.cornerRadius = 16
          imageView.layer.maskedCorners = [
               .layerMinXMaxYCorner,
               .layerMaxXMaxYCorner
           ]
          return imageView
      }()

      private let smallPosterImageView: UIImageView = {
          let imageView = UIImageView()
          imageView.contentMode = .scaleAspectFill
          imageView.clipsToBounds = true
          imageView.layer.cornerRadius = 16
          return imageView
      }()

      private let ratingView: UIView = {
          let ratingView = UIView()
          ratingView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
          ratingView.layer.cornerRadius = 12
          return ratingView
      }()

      private let ratingLabel: UILabel = {
          let label = UILabel()
          label.textColor = .systemOrange
          label.font = .systemFont(ofSize: 14, weight: .semibold)
          return label
      }()

      private let titleLabel: UILabel = {
          let label = UILabel()
          label.textColor = .white
          label.font = .systemFont(ofSize: 22, weight: .bold)
          label.numberOfLines = 2
          return label
      }()
     private let aboutLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
     }()

    
    private let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        return stack
    }()
    
    private func makeSeparator() -> UILabel {
        let label = UILabel()
        label.text = "|"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14)
        return label
    }
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
        return button
    }()

      // MARK: - Lifecycle
    var detailSegment: [DetailSegmentEnum] = DetailSegmentEnum.allCases
    private let viewModel: DetailViewModel
    
      override func viewDidLoad() {
          super.viewDidLoad()
          view.backgroundColor = .accent
          hidesBottomBarWhenPushed = true
          tableView.isHidden = true
          setupNavigationBar()
          setupUI()
          bindViewModel()
          viewModel.fetchMovieDetails(id: movieId)
          viewModel.fetchMovieReviews(id: movieId)
      }
    private func bindViewModel() {
        viewModel.onMovieDetailsUpdated = { [weak self] in
            guard let self else { return }
            self.updateUI()
            self.viewModel.fetchWatchlistStatus(
                     movieId: self.movieId
                 )
        }
        viewModel.onReviewsUpdated = { [weak self] in
             self?.tableView.reloadData()
         }
        viewModel.onWatchlistUpdated = { [weak self] isInWatchlist in
            DispatchQueue.main.async {
                let imageName = isInWatchlist ? "bookmark.fill" : "bookmark"
                self?.bookmarkButton.setImage(
                    UIImage(systemName: imageName),
                    for: .normal
                )
            }
        }

    }
    
    private let yearView = InfoItemView(icon: "calendar", text: "-")
    private let durationView = InfoItemView(icon: "clock", text: "-")
    private let genreView = InfoItemView(icon: "film", text: "-")

    
    private func updateUI() {
        guard let movie = viewModel.movieDetails else { return }

        titleLabel.text = movie.title
        aboutLabel.text = movie.overview
        ratingLabel.text = "⭐ \(String(format: "%.1f", movie.voteAverage))"

        if let posterPath = movie.posterPath {
            posterImageView.loadImage(url: posterPath)
            smallPosterImageView.loadImage(url: posterPath)
        }
        let year = movie.releaseDate.prefix(4)
        yearView.update(text: String(year))

         if let runtime = movie.runtime {
             durationView.update(text: "\(runtime) min")
         }
        
        if let firstGenre = movie.genres.first {
            genreView.update(text: firstGenre.name)
        }

    }

    private let movieId: Int

    init(viewModel: DetailViewModel, movieId: Int) {
        self.viewModel = viewModel
        self.movieId = movieId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    private func setupNavigationBar() {
        title = "Detail"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bookmarkButton)
    }
    
    @objc private func bookmarkTapped() {
        guard let movieId = viewModel.movieDetails?.id else { return }

        viewModel.toggleWatchlist(
            movieId: movieId,
            addToWatchlist: !viewModel.isInWatchlist
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let tabBar = tabBarController as? MainTabBarController {
            tabBar.hideCustomTabBar()
        }
        let indexPath = IndexPath(item: 0, section: 0)
           segmentCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let tabBar = tabBarController as? MainTabBarController {
            tabBar.showCustomTabBar()
        }
    }
    
    private func setupUI() {
       addSubviews()
       setupConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(posterImageView)
        view.addSubview(smallPosterImageView)
        view.addSubview(titleLabel)

        view.addSubview(ratingView)
        ratingView.addSubview(ratingLabel)
        
        infoStackView.addArrangedSubview(yearView)
        infoStackView.addArrangedSubview(makeSeparator())
        infoStackView.addArrangedSubview(durationView)
        infoStackView.addArrangedSubview(makeSeparator())
        infoStackView.addArrangedSubview(genreView)

        view.addSubview(infoStackView)
        view.addSubview(segmentCollectionView)
        view.addSubview(aboutLabel)
        view.addSubview(tableView)

    }

    private func setupConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(210)
        }

        ratingView.snp.makeConstraints { make in
            make.bottom.equalTo(posterImageView).inset(12)
            make.trailing.equalTo(posterImageView).inset(12)
            make.height.equalTo(32)
            make.width.equalTo(56)
        }

        ratingLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        smallPosterImageView.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView).offset(16)
            make.bottom.equalTo(posterImageView).offset(65)
            make.width.equalTo(96)
            make.height.equalTo(130)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(10)
            make.leading.equalTo(smallPosterImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(smallPosterImageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(16)
        }
        
        segmentCollectionView.snp.makeConstraints { make in
            make.top.equalTo(infoStackView.snp.bottom).offset(28)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segmentCollectionView.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        aboutLabel.snp.makeConstraints { make in
            make.top.equalTo(segmentCollectionView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        detailSegment.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieCategoryCell.reuseIdentifier,
            for: indexPath
        ) as? MovieCategoryCell
        guard let cell else { return UICollectionViewCell() }
        cell.configure(with: detailSegment[indexPath.row].title)
        return cell
    }
}

extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.selectedSegment = DetailSegmentEnum.allCases[indexPath.row]
        
        switch self.viewModel.selectedSegment {
        case .about:
            tableView.isHidden = true
            aboutLabel.isHidden = false
        case .reviews:
            tableView.isHidden = false
            aboutLabel.isHidden = true
        }
        
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       viewModel.reviews.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
             withIdentifier: ReviewTableViewCell.reuseIdentifier,
             for: indexPath
         ) as? ReviewTableViewCell
        guard let cell else { return UITableViewCell() }
        let review = viewModel.reviews[indexPath.row]

        cell.configure(
            name: review.author,
            review: review.content,
            rating: review.authorDetails.rating ?? 0.0,
            avatarURL: review.avatarURL
        )
         return cell
    }
}


