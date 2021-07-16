//
//  GetUserReposUseCase.swift
//  Training
//
//  Created by Ong Yue Huei on 12/07/2021.
//

import Combine
import Foundation

protocol GetUserReposUseCase {
    func perform(username: String, completion: @escaping (Result<[Repo], Error>) -> Void)
    func perform(username: String) -> AnyPublisher<[Repo], Error>
}

final class GetUserReposDefaultUseCase: GetUserReposUseCase {
    func perform(username: String, completion: @escaping (Result<[Repo], Error>) -> Void) {
        let request = GetUserReposRequest(username: username)
        Network.request(request, completion: completion)
    }

    func perform(username: String) -> AnyPublisher<[Repo], Error> {
        let request = GetUserReposRequest(username: username)
        return Network.request(request)
    }
}
