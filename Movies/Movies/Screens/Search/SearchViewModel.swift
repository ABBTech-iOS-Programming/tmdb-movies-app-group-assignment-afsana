import Foundation

final class SearchViewModel {
    
    var movies: MovieModel?
    
    var onSearchSuccess: () -> Void = {}
    
    private var genresDict: [Int: String] = [:]
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchMovies(query: String) {
        networkService
            .request(MoviesEndpoint.searchMovies(query: query )) { [weak self]
            (result: Result<MovieModel, NetworkError>) in
            guard let self else { return }
            
            switch result {
            case .success(let movies):
                self.movies = movies
                DispatchQueue.main.async {
                    self.onSearchSuccess()
                }
            case .failure(let error):
                print("LOG: Error decoding json: \(error)")
            }
        }
    }
    
    func fetchGenres() {
        networkService
            .request(MoviesEndpoint.getGenres) { [weak self]
                (result: Result<GenreModel, NetworkError>) in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                self.genresDict = Dictionary(uniqueKeysWithValues:
                    response.genres.map { ($0.id, $0.name) }
                )
            case .failure(let error):
                print("LOG: Error decoding json: \(error)")
            }
        }
    }
    
    func genreString(from ids: [Int]?) -> String {
        guard let ids = ids, !ids.isEmpty else {
            return "N/A"
        }
        
        let genreNames = ids.compactMap { genresDict[$0] }
        return genreNames.joined(separator: ", ")
    }
}
