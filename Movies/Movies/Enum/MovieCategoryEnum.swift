enum MovieCategoryEnum: String, CaseIterable {
    case nowPlaying
    case upcoming
    case topRated
    case popular
    
    var displayName: String {
        switch self {
        case .nowPlaying:
            return "Now playing"
        case .upcoming:
            return "Upcoming"
        case .topRated:
            return "Top rated"
        case .popular:
            return "Popular"
        }
    }
}
