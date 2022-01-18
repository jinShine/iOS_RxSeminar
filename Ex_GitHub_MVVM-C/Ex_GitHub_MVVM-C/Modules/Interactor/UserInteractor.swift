//
//  UserInteractor.swift
//  Ex_GitHub_MVVM-C
//
//  Created by buzz on 2022/01/19.
//

import RxSwift
import RxCocoa

protocol UserInteractorable {

  func fetchUserList(since: Int) -> Observable<[User]>
}

final class UserInteractor: UserInteractorable {

  let githubNetowrk: NetworkService<GitHubRouter>

  init(githubNetwork: NetworkService<GitHubRouter>) {
    self.githubNetowrk = githubNetwork
  }

  func fetchUserList(since: Int) -> Observable<[User]> {
    githubNetowrk.request(to: .userList(since: since), decode: [User].self).asObservable()
  }
}
