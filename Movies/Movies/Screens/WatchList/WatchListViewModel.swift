//
//  WatchListViewModel.swift
//  Movies
//
//  Created by Afsana on 09.01.26.
//
import Foundation
final class WatchListViewModel {

    var watchList: MovieModel?
    var onWatchListUpdated: () -> Void = {}

    private let networkService: NetworkService

    private var genresDict: [Int: String] = [:]

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchWatchList() {
        fetchGenres { [weak self] in
            guard let self else { return }

            self.networkService.request(MoviesEndpoint.getWatchList) {
                (result: Result<MovieModel, NetworkError>) in

                if case .success(let movies) = result {
                    self.watchList = movies
                    DispatchQueue.main.async {
                        self.onWatchListUpdated()
                    }
                }
            }
        }
    }

    private func fetchGenres(completion: @escaping () -> Void) {
        if !genresDict.isEmpty {
            completion()
            return
        }

        networkService.request(MoviesEndpoint.getGenres) {
            (result: Result<GenreModel, NetworkError>) in

            if case .success(let response) = result {
                self.genresDict = Dictionary(
                    uniqueKeysWithValues: response.genres.map {
                        ($0.id, $0.name)
                    }
                )
            }
            completion()
        }
    }

    func genreString(from ids: [Int]?) -> String {
        guard let ids, !ids.isEmpty else { return "N/A" }
        return ids.compactMap { genresDict[$0] }.joined(separator: ", ")
    }
}
