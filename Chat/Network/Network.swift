//
//  Network.swift
//  Chat
//
//  Created by laijihua on 2018/6/16.
//  Copyright © 2018 laijihua. All rights reserved.
//

import Foundation
import Moya
import RxSwift


// 192.168.199.189
protocol Network {
    associatedtype T: TargetType
    var provider: MoyaProvider<T> { get }
}

// MARK: Login
final class NetworkManager: Network {
    let provider = MoyaProvider<ChatApi>(plugins: [NetworkLoggerPlugin(verbose: true),
                                                   ChachePolicyPlugin(),
                                                   AccessTokenPlugin(tokenClosure: Share.shared.token?.accessToken ?? "")])
    func regist(email: String,
                password: String,
                name: String,
                disposed: DisposeBag,
                success: @escaping((ResponseContainer<TokenResult>?) -> Void),
                failure: @escaping((Error) -> Void)) {
        provider
            .rx
            .request(.registe(name: name, email: email, password: password))
            .filterSuccessfulStatusCodes()
            .subscribe(self.handleAfterRequestSuccess(success: success, failure: failure))
            .disposed(by: disposed)
    }

    func login(email: String,
               password: String,
               disposed: DisposeBag,
               success: @escaping((ResponseContainer<TokenResult>?) -> Void),
               failure: @escaping((Error) -> Void)) {

        provider
            .rx
            .request(.login(email: email, password: password))
            .filterSuccessfulStatusCodes()
            .subscribe(self.handleAfterRequestSuccess(success: success, failure: failure))
            .disposed(by: disposed)
    }
}

// Account
extension NetworkManager {
    func info(disposed: DisposeBag, success: @escaping((ResponseContainer<User>?) -> Void),
              failure: @escaping((Error) -> Void)) {
        provider
            .rx
            .request(.userInfo)
            .filterSuccessfulStatusCodes()
            .subscribe(self.handleAfterRequestSuccess(success: success, failure: failure))
            .disposed(by: disposed)
    }
}

extension Network {
     func handleAfterRequestSuccess<R: Codable>(success: @escaping ((ResponseContainer<R>?) -> Void),
                                                failure: @escaping(((Error) -> Void))) -> (SingleEvent<Response>) -> Void {
        return { (result: SingleEvent<Response>) in
            switch result {
            case let .success(response):
                do {
                    let results: ResponseContainer<R> = try response.data.makeToContainer()
                    success(results)
                } catch let error {
                    failure(error)
                }
            case let .error(error):
                failure(error)
            }
        }
    }
}




