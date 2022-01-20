//
//  Navigator+Transition.swift
//  Ex_GitHub_MVVM-C
//
//  Created by buzz on 2022/01/14.
//

import Foundation
import UIKit

enum Transition {
  case root(in: UIWindow)
  case modal
  case alert
}

protocol Transitionable {
  func show(scene: Scene, sender: UIViewController?, transitionType: Transition)
  func pop(sender: UIViewController?, toRoot: Bool)
  func dismiss(sender: UIViewController?)
}

extension Navigator: Transitionable {

  func show(
    scene: Scene,
    sender: UIViewController?,
    transitionType: Transition
  ) {

    let target = get(for: scene)

    switch transitionType {
    case .root(let window):
      UIView.transition(
        with: window, duration: 0.5, options: .transitionCrossDissolve,
        animations: {
          window.rootViewController = target
          window.backgroundColor = App.color.white
          window.makeKeyAndVisible()
        }, completion: nil)
      return
    default: break
    }

    guard let sender = sender else {
      fatalError(".navigation, .modal transition에 대한 sender가 필요합니다.")
    }

    if let nav = sender as? UINavigationController {
      nav.pushViewController(target, animated: false)
      return
    }

    switch transitionType {
    case .modal:
      DispatchQueue.main.async {
        let nav = UINavigationController(rootViewController: target)
        sender.present(nav, animated: true, completion: nil)
      }
    case .alert:
      DispatchQueue.main.async {
        sender.present(target, animated: true, completion: nil)
      }
    default:
      break
    }
  }

  func pop(sender: UIViewController?, toRoot: Bool = false) {
    if toRoot {
      sender?.navigationController?.popToRootViewController(animated: true)
    } else {
      sender?.navigationController?.popViewController(animated: true)
    }
  }

  func dismiss(sender: UIViewController?) {
    sender?.navigationController?.dismiss(animated: true, completion: nil)
  }

}
