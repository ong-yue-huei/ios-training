import Foundation

struct User: Decodable {
    let id: Int64
    let login: String
    let avatarUrl: URL
    let name: String?
    let followers: Int
    let following: Int

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
        case name
        case followers
        case following
    }
}
