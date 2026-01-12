
import Foundation

struct ReviewsResponseModel: Codable {
    let id: Int
    let page: Int
    let results: [ReviewModel]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case id
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct ReviewModel: Codable {
    let author: String
    let authorDetails: AuthorDetails
    let content: String
    let createdAt: String
    let id: String
    let updatedAt: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case id
        case updatedAt = "updated_at"
        case url
    }
}

struct AuthorDetails: Codable {
    let name: String?
    let username: String
    let avatarPath: String?
    let rating: Double?

    enum CodingKeys: String, CodingKey {
        case name
        case username
        case avatarPath = "avatar_path"
        case rating
    }
}

extension ReviewModel {
    var avatarURL: URL? {
        guard let path = authorDetails.avatarPath else { return nil }
        if path.hasPrefix("/https") {
            return URL(string: String(path.dropFirst()))
        }
        return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
    }
}
