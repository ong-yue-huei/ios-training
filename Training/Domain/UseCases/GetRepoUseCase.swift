//
//  GetReposUseCase.swift
//  Training
//
//  Created by Ong Yue Huei on 09/07/2021.
//

import Combine
import Foundation

protocol GetRepoUseCase {
    func perform(ownerRepo: String, completion: @escaping (Result<Repo, Error>) -> Void)
    func perform(ownerRepo: String) -> AnyPublisher<Repo, Error>
}

final class GetRepoDefaultUseCase: GetRepoUseCase {
    func perform(ownerRepo: String, completion: @escaping (Result<Repo, Error>) -> Void) {
        let request = GetRepoRequest(ownerRepo: ownerRepo)
        Network.request(request, completion: completion)
    }

    func perform(ownerRepo: String) -> AnyPublisher<Repo, Error> {
        let request = GetRepoRequest(ownerRepo: ownerRepo)
        return Network.request(request)
    }
}

