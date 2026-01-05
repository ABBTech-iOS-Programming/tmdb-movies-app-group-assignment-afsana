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
    init(networkService: NetworkService) {
        self.networkService = networkService
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
