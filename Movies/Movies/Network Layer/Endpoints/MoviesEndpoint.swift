import Foundation

enum MoviesEndpoint {
    case getTrendingMovies
    case getNowPlayingMovies
    case getUpcomingMovies
    case getTopRatedMovies
    case getPopularMovies
}

extension MoviesEndpoint: Endpoint {
    var bearerToken: String {
        return "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyZjVjMWRhN2FmNWQ1ZjEzNzBmODJiZDkyOWMxODA3ZiIsIm5iZiI6MTczOTAxNTcwNC4yMTUwMDAyLCJzdWIiOiI2N2E3NDYxOGRmNTVlOGYyMTNmMTBmZmIiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.oZ9VZlP5lD2DI2ozQNsJvPcaEuxN5TncMcHCuVsQWzQ"
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
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Authorization": bearerToken]
        }
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var httpBody: (any Encodable)? {
        switch self {
        default:
            return nil
        }
    }
}
