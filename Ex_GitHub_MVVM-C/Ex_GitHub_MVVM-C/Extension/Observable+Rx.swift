//
//  Observable+Rx.swift
//  Ex_GitHub_MVVM-C
//
//  Created by buzz on 2022/01/15.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {

  func mapToVoid() -> Observable<Void> {
    map { _ in }
  }

  func asDriverOnErrorJustComplete() -> Driver<Element> {
    asDriver { _ in .empty() }
  }
}
