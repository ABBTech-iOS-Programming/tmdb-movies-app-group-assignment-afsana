import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let width: CGFloat = 140
        let height = width * 1.5
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 10
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

    private let searchView = CustomSearchView()
    let movies: [UIImage] = [ .sekil, .sekill, .sekil , .sekill]
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Trending"
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "What do you want yo watch?"
        view.backgroundColor = .accent
        setupUI()
        bindSearchAction()
        configureNavigationBar()
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
        view.addSubview(collectionView)
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
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(210)
        }
        
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterCell.reuseIdentifier, for: indexPath) as? MoviePosterCell
        guard let cell else { return UICollectionViewCell() }
        let movie = movies[indexPath.item]
        cell.configure(with: movie)
        return cell
    }
    
    
}

extension HomeViewController: UICollectionViewDelegate {
    
}
