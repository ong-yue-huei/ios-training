//
//  GetUserUseCase.swift
//  Training
//
//  Created by Ong Yue Huei on 12/07/2021.
//

import Combine
import Foundation

protocol GetUserUseCase {
    func perform(username: String, completion: @escaping (Result<User, Error>) -> Void)
    func perform(username: String) -> AnyPublisher<User, Error>
}

final class GetUserDefaultUseCase: GetUserUseCase {
    func perform(username: String, completion: @escaping (Result<User, Error>) -> Void) {
        let request = GetUserRequest(username: username)
        Network.request(request, completion: completion)
    }

    func perform(username: String) -> AnyPublisher<User, Error> {
        let request = GetUserRequest(username: username)
        return Network.request(request)
    }
}
