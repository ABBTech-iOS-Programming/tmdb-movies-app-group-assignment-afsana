import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    private lazy var trendingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let spacing: CGFloat = 12
        let totalSpacing = spacing * 6
        let itemWidth = (UIScreen.main.bounds.width - totalSpacing) / 2.5
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.6)
        layout.minimumLineSpacing = spacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MoviePosterCell.self, forCellWithReuseIdentifier: MoviePosterCell.reuseIdentifier)
        collectionView.allowsSelection = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.tag = 0
        collectionView.backgroundColor = .clear

        return collectionView
    }()
    
    private lazy var categoryCollectionView: UICollectionView = {
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
        collectionView.tag = 1
        
        return collectionView
    }()
    
    private lazy var movieCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let spacing: CGFloat = 12
        let totalSpacing = spacing * 6
        let itemWidth = (UIScreen.main.bounds.width - totalSpacing) / 3
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 16, left: spacing, bottom: 16, right: spacing)
        
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .clear
        collectionView
            .register(
                MoviePosterCell.self,
                forCellWithReuseIdentifier: MoviePosterCell.reuseIdentifier
            )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.tag = 2
        return collectionView
    }()

    private let searchView = CustomSearchView()
    var displayCategories: [MovieCategoryEnum] = MovieCategoryEnum.allCases
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Trending"
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "What do you want to watch?"
        view.backgroundColor = .accent
        
        setupUI()
        bindViewModel()
        getMovies()
        bindSearchAction()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if categoryCollectionView.indexPathsForSelectedItems?.isEmpty ?? true {
            let indexPath = IndexPath(item: 0, section: 0)
            categoryCollectionView
                .selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
    }
    
    private func getMovies() {
        viewModel.fetchTrendingMovies()
        viewModel.fetchNowPlayingMovies()
        viewModel.fetchUpcomingMovies()
        viewModel.fetchTopRatedMovies()
        viewModel.fetchPopularMovies()
    }
    
    private func bindViewModel() {
        viewModel.onTrendingMoviesUpdated = { [weak self] in
            guard let self else { return }
            trendingCollectionView.reloadData()
        }
        
        viewModel.onCategoryMoviesUpdated = { [weak self] in
            guard let self else { return }
            movieCollectionView.reloadData()
        }
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold),
            .foregroundColor: UIColor.white
        ]
    }
    
    private func setupUI() {
        addSubviews()
        setupConstraints()
        
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

    private func addSubviews() {
        view.addSubview(searchView)
        view.addSubview(titleLabel)
        view.addSubview(trendingCollectionView)
        view.addSubview(categoryCollectionView)
        view.addSubview(movieCollectionView)
    }
    
    private func setupConstraints() {
    
        searchView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(18)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        trendingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(210)
        }
        
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(trendingCollectionView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(50)
        }
        
        movieCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
             return viewModel.trendingMovies?.results?.count ?? 0
        }
        
        if collectionView.tag == 1 {
            return displayCategories.count
        }
        
        return viewModel.displayMovies?.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterCell.reuseIdentifier, for: indexPath) as? MoviePosterCell
            guard let cell else { return UICollectionViewCell() }
            
            let movie = viewModel.trendingMovies?.results?[indexPath.row]
            
            cell.configure(with: movie?.posterPath)
            return cell
        }
        
        if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MovieCategoryCell.reuseIdentifier,
                for: indexPath
            ) as? MovieCategoryCell
            
            guard let cell else { return UICollectionViewCell() }
            
            cell.configure(with: displayCategories[indexPath.row].displayName)
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterCell.reuseIdentifier, for: indexPath) as? MoviePosterCell
        guard let cell else { return UICollectionViewCell() }
        
        let movie = viewModel.displayMovies?.results?[indexPath.row]
        
        cell.configure(with: movie?.posterPath)
        return cell
        
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            self.viewModel.selectedCategory = MovieCategoryEnum.allCases[indexPath.row]
            
            switch self.viewModel.selectedCategory {
                case .nowPlaying:
                    self.viewModel.displayMovies = self.viewModel.nowPlayingMovies
                case .upcoming:
                    self.viewModel.displayMovies = self.viewModel.upcomingMovies
                case .topRated:
                    self.viewModel.displayMovies = self.viewModel.topRatedMovies
                case .popular:
                    self.viewModel.displayMovies = self.viewModel.popularMovies
            }
            
            movieCollectionView.reloadData()
            
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        }
    }
}
