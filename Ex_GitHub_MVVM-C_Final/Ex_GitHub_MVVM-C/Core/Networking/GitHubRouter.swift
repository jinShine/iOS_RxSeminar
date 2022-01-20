//
//  GitHubRouter.swift
//  Ex_GitHub_MVVM-C
//
//  Created by buzz on 2022/01/19.
//

import Alamofire
import Moya

enum GitHubRouter {
  case userList(since: Int)
//  case userDetail(name: String)
//  case userRepo(name: String, page: Int)
}

extension GitHubRouter: TargetType {

  // Github Key
  static let clientID: String = "075f9bae947051708b29"
  static let clientSecret: String = "e5593a561341875f9a5a768bca8d74b398aff81e"

  var baseURL: URL {
    return URL(string: "https://api.github.com")!
  }

  var path: String {
    switch self {
    case .userList:
      return "/users"
//      case .userDetail(let name):
//          return "/users/\(name)"
//      case .userRepo(let name, _):
//          return "/users/\(name)/repos"
    }
  }

  var method: Alamofire.HTTPMethod {
    switch self {
    case .userList:
      return .get
    }
  }

//  var parameter: Parameters {
//      switch self {
//      case .userList(let since):
//          return [
//              "since" : since,
//              "client_id" : Router.clientID,
//              "client_secret" : Router.clientSecret
//          ]
//      case .userDetail:
//          return [:]
//      case .userRepo(_, let page):
//          return [
//              "page" : page
//          ]
//      }
//  }

  var task: Task {
    switch self {
    case let .userList(since):
      return .requestParameters(parameters: [
        "since" : since,
        "client_id" : GitHubRouter.clientID,
        "client_secret" : GitHubRouter.clientSecret
      ], encoding: URLEncoding.default)
    }
  }

  var headers: [String : String]? {
    return [:]
  }
}

