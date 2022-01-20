//
//  Navigator.swift
//  Ex_GitHub_MVVM-C
//
//  Created by buzz on 2022/01/14.
//

import Foundation
import UIKit

enum Scene {
  case userList
//  case userDetail
}

protocol Navigatable {

  func get(for scene: Scene) -> UIViewController
}

class Navigator: Navigatable {

  private let githubNetwork = NetworkService<GitHubRouter>()

  func get(for scene: Scene) -> UIViewController {
    return .init()
  }
}
