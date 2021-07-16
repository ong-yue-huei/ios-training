//
//  Repo.swift
//  Training
//
//  Created by Ong Yue Huei on 09/07/2021.
//
import Foundation

struct Repo: Decodable, Hashable {
    let id: Int32
    let name: String
    let fullName: String
    let isPrivate: Bool
    let owner: Owner
    let description: String?
    let updatedAt: Date
    let stargazersCount: Int
    let watchersCount: Int
    let language: String?
    let forksCount: Int
    let openIssuesCount: Int
    
    static func ==(lhs: Repo, rhs: Repo) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case isPrivate = "private"
        case owner
        case description
        case updatedAt = "updated_at"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case language
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
    }

    struct Owner: Decodable {
        let id: Int32
        let avatarURL: URL
        
        enum CodingKeys: String, CodingKey {
            case id
            case avatarURL = "avatar_url"
        }
    }
}
