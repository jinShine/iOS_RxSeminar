//
//  UIView+Extension.swift
//  Ex_GitHub_MVVM-C
//
//  Created by buzz on 2022/01/19.
//

import UIKit

public extension UIView {

  func addSubviews(_ views: [UIView]) {
    views.forEach {
      self.addSubview($0)
    }
  }
}

extension UIView {

  static var reuseIdentifier: String {
    let nameSpaceClassName = NSStringFromClass(self)
    guard let className = nameSpaceClassName.components(separatedBy: ".").last else {
      return nameSpaceClassName
    }
    return className
  }

  class func nib() -> UINib {
    return UINib(nibName: reuseIdentifier, bundle: nil)
  }
}
