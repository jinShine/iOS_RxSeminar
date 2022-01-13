//
//  App.swift
//  Ex_GitHub_MVVM-C
//
//  Created by buzz on 2022/01/14.
//

import Foundation
import UIKit

final class App: NSObject {

  /// singleton
  static let shared = App()

  // MARK: - Properties

  var window: UIWindow?
  var windowScene: UIWindowScene?
  let navigator: Navigator

  private override init() {
    self.navigator = Navigator()
    super.init()
  }

  func presentInitialScreen(in window: UIWindow, with windowScene: UIWindowScene, options connectionOptions: UIScene.ConnectionOptions) {
    self.window = window
    self.windowScene = windowScene
    self.window?.backgroundColor = App.color.white
    self.window?.makeKeyAndVisible()

    self.navigator.show(scene: .userList, sender: nil, transitionType: .root(in: window))
  }
}
