//
//  User.swift
//  Ex_GitHub_MVVM-C
//
//  Created by buzz on 2022/01/15.
//

import Foundation

struct User: Decodable {
  var id: Int = 0
  var name: String = ""
  var profile: String = ""

  enum CodingKeys: String, CodingKey {
    case id
    case name = "login"
    case profile = "avatar_url"
  }
}
