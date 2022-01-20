//
//  UserInfoTableViewCellViewModel.swift
//  Ex_GitHub_MVVM-C
//
//  Created by buzz on 2022/01/19.
//

import Foundation

struct UserInfoTableViewCellViewModel {

  // MARK: - Properties

  let user: User

  // MARK: - Initialize

  init(user: User) {
    self.user = user
  }

  // MARK: - Helper

  var profileURL: URL? {
    URL(string: user.profile)
  }

  var name: String {
    user.name
  }
}
