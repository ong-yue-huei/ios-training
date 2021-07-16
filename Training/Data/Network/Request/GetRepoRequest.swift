//
//  GetReposRequest.swift
//  Training
//
//  Created by Ong Yue Huei on 09/07/2021.
//

import Alamofire

struct GetRepoRequest: BaseRequest {
    typealias Response = Repo
    var path: String = "/repos/"
    var method: HTTPMethod = .get

    init(ownerRepo: String) {
        path += ownerRepo
    }
}
