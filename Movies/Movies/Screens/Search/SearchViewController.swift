import UIKit
import SnapKit

final class SearchViewController: UIViewController {

    private let searchView = CustomSearchView()
    
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
            icon: "no_results1",
            title: "We Are Sorry, We Can Not Find The Movie :(",
            subtitle: "Find your movie by Type title, categories, years, etc"
        )
        view.isHidden = true
        return view
    }()
    
    let viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .accent
        navigationItem.backButtonDisplayMode = .minimal
        searchView.isEditable = true
        setupUI()
        setupSearchHandler()
        bindViewModel()
        viewModel.fetchGenres()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.textField.becomeFirstResponder()
    }

    private func setupUI() {
        view.addSubview(searchView)
        view.addSubview(tableView)
        view.addSubview(emptyStateView)

        searchView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
        
        emptyStateView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    private func setupSearchHandler() {
        searchView.textField.addTarget(
            self,
            action: #selector(searchTextChanged),
            for: .editingChanged
        )
    }
    
    @objc private func searchTextChanged() {
        let searchText = searchView.textField.text?.lowercased() ?? ""
        
        viewModel.fetchMovies(query: searchText)
        
        emptyStateView.isHidden = true
        tableView.isHidden = false
        
        if viewModel.movies?.results?.count == 0 {
            emptyStateView.isHidden = false
            tableView.isHidden = true
        }
    }
    
    private func bindViewModel() {
        viewModel.onSearchSuccess = { [weak self] in
            guard let self else { return }
            tableView.reloadData()
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies?.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "MovieCell",
            for: indexPath
        ) as? MovieCell else {
            return UITableViewCell()
        }
        
        if let movie = viewModel.movies?.results?[indexPath.row] {
            cell
                .configure(
                    with: movie,
                    genre: viewModel.genreString(from: movie.genreIDS)
                )
        }
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movie = viewModel.movies?.results?[indexPath.row] else {
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
