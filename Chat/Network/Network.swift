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
    associatedtype T: TargetType, ChatAPIType
    var provider: MoyaProvider<T> { get }
}

// MARK: Login
final class NetworkManager: Network {
    let provider = MoyaProvider<ChatApi>(plugins: [NetworkLoggerPlugin(verbose: true),
                                                   ChachePolicyPlugin(),
                                                   AccessTokenPlugin(tokenClosure: Share.shared.token?.accessToken ?? "")])
}

// Account
extension NetworkManager {

    private func actureRequest<R: Codable>(_ token: ChatApi,
                                           disposed: DisposeBag,
                                           success: @escaping ((Response<R>) -> Void),
                                        failure: @escaping((Error) -> Void)) {
        self.provider
            .rx
            .request(token)
            .filterSuccessfulStatusCodes()
            .map(Response<R>.self)
            .subscribe(onSuccess: { (response) in
                success(response)
            }, onError: { error in
                failure(error)
            })
            .disposed(by: disposed)
    }

    func request<R: Codable>(_ token: ChatApi,
                             disposed: DisposeBag,
                             success: @escaping ((Response<R>) -> Void),
                             failure: @escaping((Error) -> Void)) {
        if token.addAuth {
            guard let appToken = Share.shared.token else { return }
            if appToken.isValid { return }
            self.actureRequest(ChatApi.tokenRefresh(refreshToken: appToken.refreshToken),
                                      disposed: disposed,
                                      success: { (response: Response<Token>) in
                                            self.actureRequest(token, disposed: disposed, success:success, failure: failure)
                                      },
                                      failure: failure)
        } else {
            self.actureRequest(token, disposed: disposed, success:success, failure: failure)
        }
    }
}


extension NetworkManager {


    func appTokenRequest(_ share: Share = Share.shared) {




    }
}






