//
//  NetworkService.swift
//  Ex_GitHub_MVVM-C
//
//  Created by buzz on 2022/01/14.
//

import Alamofire
import Moya
import RxSwift

struct NetworkService {

  private let provider: MoyaProvider<Router> = {
    let provider = MoyaProvider<Router>(
      endpointClosure: MoyaProvider.defaultEndpointMapping,
      requestClosure: MoyaProvider<Router>.defaultRequestMapping,
      stubClosure: MoyaProvider.neverStub,
      callbackQueue: nil,
      session: AlamofireSession.configuration,
      plugins: [NetworkLoggerPlugin()],
      trackInflights: false
    )
    return provider
  }()

  func request<T: Decodable>(to router: Router, decode: T.Type) -> Single<T> {
    provider.rx.request(router)
      .filterSuccessfulStatusCodes()
      .map(T.self)
      .retry(3)
  }
}
