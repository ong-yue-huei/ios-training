//
//  GetUserRequest.swift
//  Training
//
//  Created by Ong Yue Huei on 12/07/2021.
//

import Alamofire

struct GetUserRequest: BaseRequest {
    typealias Response = User
    var path: String = "/users/"
    var method: HTTPMethod = .get

    init(username: String) {
        path += username
    }
}
