import Foundation

final class HomeViewModel {
    var trendingMovies: MovieModel?
    var onTrendingMoviesUpdated: () -> Void = {}
    
    var nowPlayingMovies: MovieModel?
    var upcomingMovies: MovieModel?
    var topRatedMovies: MovieModel?
    var popularMovies: MovieModel?
    
    var onCategoryMoviesUpdated: () -> Void = {}
    
    var onError: () -> Void = {}
    
    var displayMovies: MovieModel?
    var selectedCategory: MovieCategoryEnum = MovieCategoryEnum.nowPlaying
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchTrendingMovies() {
        networkService.request(MoviesEndpoint.getTrendingMovies) { [weak self]
            (result: Result<MovieModel, NetworkError>) in
            guard let self else { return }
            
            switch result {
            case .success(let movies):
                self.trendingMovies = movies
                DispatchQueue.main.async {
                    self.onTrendingMoviesUpdated()
                }
            case .failure(let error):
                print("LOG: Error decoding json: \(error)")
            }
        }
    }
    
    func fetchNowPlayingMovies() {
        networkService.request(MoviesEndpoint.getNowPlayingMovies) { [weak self]
            (result: Result<MovieModel, NetworkError>) in
            guard let self else { return }
            
            switch result {
            case .success(let movies):
                self.nowPlayingMovies = movies
                
                if self.selectedCategory == .nowPlaying {
                    self.displayMovies = self.nowPlayingMovies
                }
                
                DispatchQueue.main.async {
                    self.onCategoryMoviesUpdated()
                }
            case .failure(let error):
                print("LOG: Error decoding json: \(error)")
            }
        }
    }
    
    func fetchUpcomingMovies() {
        networkService.request(MoviesEndpoint.getUpcomingMovies) { [weak self]
            (result: Result<MovieModel, NetworkError>) in
            guard let self else { return }
            
            switch result {
            case .success(let movies):
                self.upcomingMovies = movies
                
                if self.selectedCategory == .upcoming {
                    self.displayMovies = self.upcomingMovies
                }
                
                DispatchQueue.main.async {
                    self.onCategoryMoviesUpdated()
                }
            case .failure(let error):
                print("LOG: Error decoding json: \(error)")
            }
        }
    }
    
    func fetchTopRatedMovies() {
        networkService.request(MoviesEndpoint.getTopRatedMovies) { [weak self]
            (result: Result<MovieModel, NetworkError>) in
            guard let self else { return }
            
            switch result {
            case .success(let movies):
                self.topRatedMovies = movies
                
                if self.selectedCategory == .topRated {
                    self.displayMovies = self.topRatedMovies
                }
                
                DispatchQueue.main.async {
                    self.onCategoryMoviesUpdated()
                }
            case .failure(let error):
                print("LOG: Error decoding json: \(error)")
            }
        }
    }
    
    func fetchPopularMovies() {
        networkService.request(MoviesEndpoint.getPopularMovies) { [weak self]
            (result: Result<MovieModel, NetworkError>) in
            guard let self else { return }
            
            switch result {
            case .success(let movies):
                self.popularMovies = movies
                
                if self.selectedCategory == .popular {
                    self.displayMovies = self.popularMovies
                }
                
                DispatchQueue.main.async {
                    self.onCategoryMoviesUpdated()
                }
            case .failure(let error):
                print("LOG: Error decoding json: \(error)")
            }
        }
    }
}
