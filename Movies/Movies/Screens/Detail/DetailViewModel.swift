//
//  DetailViewModel.swift
//  Movies
//
//  Created by Afsana on 04.01.26.
//
import Foundation

final class DetailViewModel {
    var selectedSegment: DetailSegmentEnum = DetailSegmentEnum.about
    
    private let networkService: NetworkService
    var movieDetails: MovieDetailsModel?
    var onMovieDetailsUpdated: () -> Void = {}
    var reviews: [ReviewModel] = []
    var onReviewsUpdated: () -> Void = {}
    private(set) var isInWatchlist: Bool = false
     var onWatchlistUpdated: ((Bool) -> Void)?
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchWatchlistStatus(movieId: Int) {
        networkService.request(
            MoviesEndpoint.getStates(movieId: movieId)
        ) { [weak self] (result: Result<AccountStatesResponse, NetworkError>) in
            guard let self else { return }

            switch result {
            case .success(let state):
                print("WATCHLIST STATE FROM API:", state.watchlist)
                self.isInWatchlist = state.watchlist
                DispatchQueue.main.async {
                    self.onWatchlistUpdated?(state.watchlist)
                }

            case .failure(let error):
                print("LOG: fetchWatchlistStatus error → \(error)")
            }
        }
    }


    
    func toggleWatchlist(
        movieId: Int,
        addToWatchlist: Bool
    ) {
        let body = WatchlistRequest(
            mediaType: "movie",
            mediaId: movieId,
            watchlist: addToWatchlist
        )

        let endpoint = MoviesEndpoint.addWatchList(
            body: body
        )

        networkService.request(endpoint) { [weak self]
            (result: Result<WatchlistResponse, NetworkError>) in
            guard let self else { return }

            switch result {
            case .success:
                self.isInWatchlist = addToWatchlist
                DispatchQueue.main.async {
                    self.onWatchlistUpdated?(addToWatchlist)
                }

            case .failure(let error):
                print("LOG: Watchlist error → \(error)")
            }
        }
    }

    func fetchMovieDetails(id: Int) {
        networkService.request(MoviesEndpoint.getMovieDetails(id: id)) { [weak self]
            (result: Result<MovieDetailsModel, NetworkError>) in
            guard let self else { return }
            
            switch result {
            case .success(let movieDetails):
                self.movieDetails = movieDetails
                DispatchQueue.main.async {
                    self.onMovieDetailsUpdated()
                }
            case .failure(let error):
                print("LOG: Error decoding json: \(error)")
            }
        }
    }
    
    func fetchMovieReviews(id: Int) {
        networkService.request(MoviesEndpoint.getMovieReviews(id: id)) { [weak self]
            ( result: Result<ReviewsResponseModel, NetworkError>) in
            guard let self else { return }
            
            switch result {
            case .success(let movieReviews):
                self.reviews = movieReviews.results
                DispatchQueue.main.async {
                    self.onReviewsUpdated()
                }
            case .failure(let error):
                print("LOG: Error decoding json: \(error)")
            }
        }
    }
    
}
