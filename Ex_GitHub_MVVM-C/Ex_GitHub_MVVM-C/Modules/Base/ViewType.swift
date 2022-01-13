//
//  ViewType.swift
//  Ex_GitHub_MVVM-C
//
//  Created by buzz on 2022/01/14.
//

import Foundation

protocol ViewType: AnyObject {
  associatedtype ViewModelType

  var viewModel: ViewModelType { get }
}
