//
//  NetworkService.swift
//  Ex_GitHub_MVVM-C
//
//  Created by buzz on 2022/01/14.
//

import Alamofire
import Moya
import RxSwift

public protocol Networkable {
  associatedtype Router

  func request<T: Decodable>(
    to router: Router,
    decode: T.Type
  ) -> Single<T>
}

struct NetworkService<R: TargetType>: Networkable {

  private let provider: MoyaProvider<R> = {
    let provider = MoyaProvider<R>(
      endpointClosure: MoyaProvider.defaultEndpointMapping,
      requestClosure: MoyaProvider<R>.defaultRequestMapping,
      stubClosure: MoyaProvider.neverStub,
      callbackQueue: nil,
      session: AlamofireSession.configuration,
      plugins: [NetworkLoggerPlugin()],
      trackInflights: false
    )

    return provider
  }()

  func request<T: Decodable>(to router: R, decode: T.Type) -> Single<T> {
    provider.rx.request(router)
      .filterSuccessfulStatusCodes()
      .map(T.self)
      .retry(3)
  }
}
