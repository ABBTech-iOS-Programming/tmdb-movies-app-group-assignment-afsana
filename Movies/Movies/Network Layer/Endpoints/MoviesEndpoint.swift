import Foundation

enum MoviesEndpoint {
    case getTrendingMovies
    case getNowPlayingMovies
    case getUpcomingMovies
    case getTopRatedMovies
    case getPopularMovies
    
    case searchMovies(query: String)
    case getGenres
    
    case getMovieDetails(id: Int)
    case getMovieReviews(id: Int)
    
    case addWatchList(body: WatchlistRequest)
    case getWatchList
    case getStates(movieId: Int)

}

extension MoviesEndpoint: Endpoint {
    var bearerToken: String {
        return "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlZDBjMmI2YzkwZTM1YzFmMjU4ZTI0MzQzODI1NmMzYSIsIm5iZiI6MTc2ODA3MDQ5NC4wMDMsInN1YiI6IjY5NjI5ZDVkYTMyNTdiMjU5NmJkMzliZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.8vPqhm3M73ELShTu691gkWxsEInwyiZcwdJZg4UqYj0"
    }
    
    var baseURL: String {
        return "https://api.themoviedb.org"
    }

    var path: String {
        switch self {
        case .getTrendingMovies:
            return "/3/trending/movie/day"
        case .getNowPlayingMovies:
            return "/3/movie/now_playing"
        case .getUpcomingMovies:
            return "/3/movie/upcoming"
        case .getTopRatedMovies:
            return "/3/movie/top_rated"
        case .getPopularMovies:
            return "/3/movie/popular"
        case .searchMovies:
            return "/3/search/movie"
        case .getGenres:
            return "/3/genre/movie/list"
        case .getMovieDetails(let id):
            return "/3/movie/\(id)"
        case .getMovieReviews(let id):
            return "/3/movie/\(id)/reviews"
        case .addWatchList:
            return "/3/account/22643024/watchlist"
        case .getWatchList:
            return "/3/account/22643024/watchlist/movies"
        case .getStates(let id):
            return "/3/movie/\(id)/account_states"
    
        }
    }
        
    var method: HttpMethod {
        switch self {
        case .getTrendingMovies:
            return .get
        case .getNowPlayingMovies:
            return .get
        case .getUpcomingMovies:
            return .get
        case .getTopRatedMovies:
            return .get
        case .getPopularMovies:
            return .get
        case .searchMovies:
            return .get
        case .getGenres:
            return .get
        case .getMovieDetails:
            return .get
        case  .getMovieReviews:
            return .get
        case .addWatchList:
            return .post
        case .getWatchList:
            return .get
        case .getStates:
            return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .addWatchList:
             return [
                 "Authorization": bearerToken,
                 "Content-Type": "application/json"
             ]
            default:
                return ["Authorization": bearerToken]
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
            case .searchMovies(let query):
                return [
                    URLQueryItem(name: "query", value: query)
                ]
            default:
                return []
        }
    }
    
    var httpBody: (any Encodable)? {
        switch self {
        case .addWatchList(let body):
               return body
        default:
            return nil
        }
    }
}
