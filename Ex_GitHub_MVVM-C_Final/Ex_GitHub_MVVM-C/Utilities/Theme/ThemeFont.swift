//
//  ThemeFont.swift
//  Ex_GitHub_MVVM-C
//
//  Created by buzz on 2022/01/14.
//

import Foundation
import UIKit

struct ThemeFont {

  enum FontType {
    case light, regular, medium, semibold, bold
  }

  func typeName(type: FontType, size: CGFloat) -> UIFont {
    var fontName: String = ""

    switch type {
    case .light:
      fontName = "AppleSDGothicNeo-Light"
    case .regular:
      fontName = "AppleSDGothicNeo-Regular"
    case .medium:
      fontName = "AppleSDGothicNeo-Medium"
    case .semibold:
      fontName = "AppleSDGothicNeo-SemiBold"
    case .bold:
      fontName = "AppleSDGothicNeo-Bold"
    }

    return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
  }
}
