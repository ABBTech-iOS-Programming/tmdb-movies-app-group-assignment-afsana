import UIKit
import SnapKit

final class WatchListViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table
            .register(
                MovieCell.self,
                forCellReuseIdentifier: MovieCell.reuseIdentifier
            )
        table.dataSource = self
        table.delegate = self
        table.keyboardDismissMode = .onDrag
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    private let emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.configure(
            icon: "box",
            title: "There is no movie yet!",
            subtitle: "Find your movie by Type title, categories, years, etc"
        )
        view.isHidden = true
        return view
    }()
    
    let viewModel: WatchListViewModel
    
    init(viewModel: WatchListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonDisplayMode = .minimal
        setupUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchWatchList()
        applyNavBarStyle()
    }
    
    private func applyNavBarStyle() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .accent
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .accent
        title = "Watch List"
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        emptyStateView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
        }

    }

    // MARK: - Bind
    private func updateEmptyState() {
        let isEmpty = (viewModel.watchList?.results?.isEmpty ?? true)

        tableView.isHidden = isEmpty
        emptyStateView.isHidden = !isEmpty
    }
    
    private func bindViewModel() {
        viewModel.onWatchListUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.updateEmptyState()
            }
        }
    }
}



extension WatchListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.watchList?.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "MovieCell",
            for: indexPath
        ) as? MovieCell else {
            return UITableViewCell()
        }
        
        if let movie = viewModel.watchList?.results?[indexPath.row] {
            cell.configure(
                 with: movie,
                 genre: viewModel.genreString(from: movie.genreIDS)
             )
        }
        
        return cell
    }
}

extension WatchListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movie = viewModel.watchList?.results?[indexPath.row] else {
            return
        }
        guard let movieId = movie.id else {
            return
        }
        let networkService = DefaultNetworkService()
        let detailViewModel = DetailViewModel(networkService:networkService )
        let detailVC = DetailViewController(viewModel: detailViewModel, movieId: movieId )
     
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

