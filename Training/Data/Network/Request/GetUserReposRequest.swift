//
//  GetUserReposRequest.swift
//  Training
//
//  Created by Ong Yue Huei on 12/07/2021.
//

import Alamofire

struct GetUserReposRequest: BaseRequest {
    typealias Response = [Repo]
    var path: String = "/users/"
    var method: HTTPMethod = .get

    init(username: String) {
        path += username + "/repos"
    }
}
