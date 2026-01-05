
enum DetailSegmentEnum: Int, CaseIterable {
    case about
    case reviews

    var title: String {
        switch self {
        case .about:
            return "About Movie"
        case .reviews:
            return "Reviews"
        }
    }
}
